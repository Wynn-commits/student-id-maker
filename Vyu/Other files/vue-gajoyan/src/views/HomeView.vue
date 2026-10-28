<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'

type Role = 'admin' | 'librarian' | 'member'
type User = { id: number; name: string; email: string; role: Role }
type Book = {
  id: number
  isbn: string | null
  title: string
  author: string
  category: string
  total_copies: number
  available_copies: number
}
type Loan = {
  id: number
  member_id: number
  book_id: number
  borrowed_at: string
  due_at: string
  returned_at: string | null
  title: string
  member: string
}
type Member = { id: number; name: string; email: string }
type Section = 'overview' | 'catalog' | 'loans' | 'members'

function readStoredUser(): User | null {
  try {
    return JSON.parse(localStorage.getItem('cpsu-library-user') || 'null') as User | null
  } catch {
    return null
  }
}

const token = ref(localStorage.getItem('cpsu-library-token'))
const user = ref<User | null>(readStoredUser())
const section = ref<Section>('overview')
const books = ref<Book[]>([])
const loans = ref<Loan[]>([])
const members = ref<Member[]>([])
const search = ref('')
const loading = ref(true)
const busy = ref(false)
const modal = ref<'book' | 'member' | 'loan' | null>(null)
const feedback = ref('')
const feedbackKind = ref<'error' | 'success'>('success')
const authMode = ref<'login' | 'signup'>('login')
const loginForm = ref({ email: '', password: '' })
const signupForm = ref({ name: '', email: '', password: '', confirmPassword: '' })
const bookForm = ref({ isbn: '', title: '', author: '', category: '', total_copies: 1 })
const memberForm = ref({ name: '', email: '', password: '' })
const loanForm = ref({ member_id: '', book_id: '', days: 14 })

const isStaff = computed(() => user.value?.role === 'admin' || user.value?.role === 'librarian')
const activeLoans = computed(() => loans.value.filter((loan) => !loan.returned_at))
const overdueLoans = computed(() =>
  activeLoans.value.filter((loan) => new Date(loan.due_at) < new Date()),
)
const availableBooks = computed(() => books.value.filter((book) => book.available_copies > 0))
const filteredBooks = computed(() => {
  const term = search.value.trim().toLowerCase()
  if (!term) return books.value
  return books.value.filter((book) =>
    [book.title, book.author, book.category, book.isbn].some((value) =>
      value?.toLowerCase().includes(term),
    ),
  )
})
const filteredLoans = computed(() => {
  const term = search.value.trim().toLowerCase()
  return loans.value.filter(
    (loan) =>
      !term || loan.title.toLowerCase().includes(term) || loan.member.toLowerCase().includes(term),
  )
})
const filteredMembers = computed(() => {
  const term = search.value.trim().toLowerCase()
  return members.value.filter(
    (member) =>
      !term ||
      member.name.toLowerCase().includes(term) ||
      member.email.toLowerCase().includes(term),
  )
})
const pageTitle = computed(
  () =>
    ({ overview: 'Overview', catalog: 'Book catalog', loans: 'Circulation', members: 'Members' })[
      section.value
    ],
)
const initials = computed(() =>
  (user.value?.name || 'Library Staff')
    .split(' ')
    .map((part) => part[0])
    .slice(0, 2)
    .join('')
    .toUpperCase(),
)

async function api<T>(path: string, options: RequestInit = {}): Promise<T> {
  const headers = new Headers(options.headers)
  headers.set('Content-Type', 'application/json')
  if (token.value) headers.set('Authorization', `Bearer ${token.value}`)
  const response = await fetch(`/api${path}`, { ...options, headers })
  const payload = (await response.json().catch(() => ({}))) as { error?: string } & T
  if (!response.ok) throw new Error(payload.error || 'The request could not be completed.')
  return payload
}

function setFeedback(message: string, kind: 'error' | 'success' = 'success') {
  feedback.value = message
  feedbackKind.value = kind
}

async function refreshData() {
  const [bookRows, loanRows, memberRows] = await Promise.all([
    api<Book[]>('/books'),
    api<Loan[]>('/loans'),
    isStaff.value ? api<Member[]>('/auth/members') : Promise.resolve([] as Member[]),
  ])
  books.value = bookRows
  loans.value = loanRows
  members.value = memberRows
}

async function signIn() {
  busy.value = true
  feedback.value = ''
  try {
    const result = await api<{ token: string; user: User }>('/auth/login', {
      method: 'POST',
      body: JSON.stringify(loginForm.value),
    })
    token.value = result.token
    user.value = result.user
    localStorage.setItem('cpsu-library-token', result.token)
    localStorage.setItem('cpsu-library-user', JSON.stringify(result.user))
    await refreshData()
  } catch (error) {
    setFeedback(error instanceof Error ? error.message : 'Unable to sign in.', 'error')
  } finally {
    busy.value = false
    loading.value = false
  }
}

async function signUp() {
  if (signupForm.value.password !== signupForm.value.confirmPassword) {
    setFeedback('Passwords do not match.', 'error')
    return
  }
  busy.value = true
  feedback.value = ''
  try {
    await api('/auth/signup', {
      method: 'POST',
      body: JSON.stringify({
        name: signupForm.value.name,
        email: signupForm.value.email,
        password: signupForm.value.password,
      }),
    })
    const result = await api<{ token: string; user: User }>('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email: signupForm.value.email, password: signupForm.value.password }),
    })
    token.value = result.token
    user.value = result.user
    localStorage.setItem('cpsu-library-token', result.token)
    localStorage.setItem('cpsu-library-user', JSON.stringify(result.user))
    await refreshData()
  } catch (error) {
    setFeedback(error instanceof Error ? error.message : 'Unable to create your account.', 'error')
  } finally {
    busy.value = false
    loading.value = false
  }
}

function signOut() {
  token.value = null
  user.value = null
  books.value = []
  loans.value = []
  members.value = []
  localStorage.removeItem('cpsu-library-token')
  localStorage.removeItem('cpsu-library-user')
  feedback.value = ''
}

function openModal(name: 'book' | 'member' | 'loan') {
  feedback.value = ''
  modal.value = name
  if (name === 'loan') {
    loanForm.value = {
      member_id: members.value[0] ? String(members.value[0].id) : '',
      book_id: availableBooks.value[0] ? String(availableBooks.value[0].id) : '',
      days: 14,
    }
  }
}

async function createBook() {
  busy.value = true
  try {
    await api('/books', { method: 'POST', body: JSON.stringify(bookForm.value) })
    await refreshData()
    modal.value = null
    bookForm.value = { isbn: '', title: '', author: '', category: '', total_copies: 1 }
    setFeedback('Book added to the catalog.')
  } catch (error) {
    setFeedback(error instanceof Error ? error.message : 'Unable to add book.', 'error')
  } finally {
    busy.value = false
  }
}

async function createMember() {
  busy.value = true
  try {
    await api('/auth/members', { method: 'POST', body: JSON.stringify(memberForm.value) })
    await refreshData()
    modal.value = null
    memberForm.value = { name: '', email: '', password: '' }
    setFeedback('Member account created.')
  } catch (error) {
    setFeedback(error instanceof Error ? error.message : 'Unable to create member.', 'error')
  } finally {
    busy.value = false
  }
}

async function createLoan() {
  busy.value = true
  try {
    await api('/loans', {
      method: 'POST',
      body: JSON.stringify({
        member_id: Number(loanForm.value.member_id),
        book_id: Number(loanForm.value.book_id),
        days: loanForm.value.days,
      }),
    })
    await refreshData()
    modal.value = null
    setFeedback('Checkout recorded. The book is now on loan.')
  } catch (error) {
    setFeedback(error instanceof Error ? error.message : 'Unable to record checkout.', 'error')
  } finally {
    busy.value = false
  }
}

async function returnBook(loan: Loan) {
  busy.value = true
  try {
    await api(`/loans/${loan.id}/return`, { method: 'POST' })
    await refreshData()
    setFeedback(`“${loan.title}” has been checked in.`)
  } catch (error) {
    setFeedback(error instanceof Error ? error.message : 'Unable to return this book.', 'error')
  } finally {
    busy.value = false
  }
}

function formatDate(value: string) {
  return new Intl.DateTimeFormat('en', { month: 'short', day: 'numeric', year: 'numeric' }).format(
    new Date(value),
  )
}

function isOverdue(loan: Loan) {
  return !loan.returned_at && new Date(loan.due_at) < new Date()
}

onMounted(async () => {
  if (!token.value) {
    loading.value = false
    return
  }
  try {
    if (!user.value) user.value = await api<User>('/auth/me')
    await refreshData()
  } catch {
    signOut()
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <main v-if="loading" class="loading-screen">
    <div class="brand-mark">C</div>
    <span>Opening the library</span>
  </main>

  <main v-else-if="!user" class="login-page">
    <section class="login-aside">
      <div class="login-brand"><span class="brand-mark">C</span><span>CPSU Library</span></div>
      <div class="login-message">
        <p class="eyebrow">CENTRAL PHILIPPINE STATE UNIVERSITY</p>
        <h1>A place for every idea to find its next chapter.</h1>
        <p>Library services, thoughtfully organized for the CPSU community.</p>
      </div>
      <div class="login-footer">
        <span>Knowledge in motion</span><span>Negros Occidental · Philippines</span>
      </div>
    </section>
    <section class="login-panel">
      <div class="login-form-wrap">
        <p class="eyebrow">{{ authMode === 'login' ? 'LIBRARY ACCOUNT' : 'CPSU COMMUNITY' }}</p>
        <h2>{{ authMode === 'login' ? 'Welcome back' : 'Create your account' }}</h2>
        <p class="muted">
          {{
            authMode === 'login'
              ? 'Sign in to continue to the library.'
              : 'Join the CPSU library community.'
          }}
        </p>
        <form class="stack-form" @submit.prevent="authMode === 'login' ? signIn() : signUp()">
          <label v-if="authMode === 'signup'"
            >Full name<input
              v-model="signupForm.name"
              type="text"
              autocomplete="name"
              maxlength="200"
              placeholder="Your full name"
              required
          /></label>
          <label v-if="authMode === 'login'"
            >Email address<input
              v-model="loginForm.email"
              type="email"
              autocomplete="username"
              placeholder="name@cpsu.edu.ph"
              required
          /></label>
          <label v-else
            >Email address<input
              v-model="signupForm.email"
              type="email"
              autocomplete="email"
              placeholder="name@cpsu.edu.ph"
              required
          /></label>
          <label v-if="authMode === 'login'"
            >Password<input
              v-model="loginForm.password"
              type="password"
              autocomplete="current-password"
              placeholder="Enter your password"
              required
          /></label>
          <label v-else
            >Password<input
              v-model="signupForm.password"
              type="password"
              autocomplete="new-password"
              minlength="12"
              placeholder="At least 12 characters"
              required
          /></label>
          <label v-if="authMode === 'signup'"
            >Confirm password<input
              v-model="signupForm.confirmPassword"
              type="password"
              autocomplete="new-password"
              minlength="12"
              placeholder="Re-enter your password"
              required
          /></label>
          <p v-if="feedback" class="form-feedback error-text">{{ feedback }}</p>
          <button class="button button-primary button-wide" :disabled="busy" type="submit">
            {{
              busy
                ? authMode === 'login'
                  ? 'Signing in…'
                  : 'Creating account…'
                : authMode === 'login'
                  ? 'Sign in'
                  : 'Create account'
            }}
          </button>
        </form>
        <p class="login-note">
          {{ authMode === 'login' ? 'New to the library?' : 'Already have an account?' }}
          <button
            class="auth-switch"
            type="button"
            @click="
              authMode = authMode === 'login' ? 'signup' : 'login'
              ;feedback = ''
            "
          >
            {{ authMode === 'login' ? 'Sign up' : 'Sign in' }}
          </button>
        </p>
      </div>
    </section>
  </main>

  <div v-else class="app-layout">
    <aside class="sidebar">
      <div class="brand-lockup">
        <span class="brand-mark">C</span><span class="brand-name">CPSU <small>LIBRARY</small></span>
      </div>
      <div class="branch-label"><span class="status-dot"></span> MAIN LIBRARY</div>
      <nav class="side-nav" aria-label="Main navigation">
        <p class="nav-caption">WORKSPACE</p>
        <button
          :class="['nav-link', { selected: section === 'overview' }]"
          @click="section = 'overview'"
        >
          <span class="nav-icon">⌂</span>Overview
        </button>
        <button
          :class="['nav-link', { selected: section === 'catalog' }]"
          @click="section = 'catalog'"
        >
          <span class="nav-icon">▤</span>Book catalog<span class="nav-count">{{
            books.length
          }}</span>
        </button>
        <button :class="['nav-link', { selected: section === 'loans' }]" @click="section = 'loans'">
          <span class="nav-icon">↗</span>Circulation<span
            v-if="activeLoans.length"
            class="nav-count"
            >{{ activeLoans.length }}</span
          >
        </button>
        <button
          v-if="isStaff"
          :class="['nav-link', { selected: section === 'members' }]"
          @click="section = 'members'"
        >
          <span class="nav-icon">◉</span>Members<span class="nav-count">{{ members.length }}</span>
        </button>
      </nav>
      <div class="sidebar-bottom">
        <div class="branch-card">
          <span class="branch-emblem">C</span
          ><span><strong>CPSU Knowledge Hub</strong><small>Collection services</small></span>
        </div>
        <button class="user-menu" @click="signOut">
          <span class="avatar">{{ initials }}</span
          ><span class="user-meta"
            ><strong>{{ user.name }}</strong
            ><small>{{ user.role }}</small></span
          ><span class="logout-glyph" aria-label="Sign out" title="Sign out">↪</span>
        </button>
      </div>
    </aside>

    <div class="main-column">
      <header class="topbar">
        <div class="breadcrumbs">
          <span>Library</span><span class="crumb-slash">/</span><strong>{{ pageTitle }}</strong>
        </div>
        <div class="topbar-right">
          <span class="live-status"><span class="status-dot"></span>Database connected</span
          ><button
            class="avatar avatar-small"
            :title="`Signed in as ${user.name}; click to sign out`"
            @click="signOut"
          >
            {{ initials }}
          </button>
        </div>
      </header>

      <section class="page-content">
        <div
          v-if="feedback"
          :class="['toast', feedbackKind === 'error' ? 'toast-error' : 'toast-success']"
          role="status"
        >
          <span>{{ feedback }}</span
          ><button aria-label="Dismiss message" @click="feedback = ''">×</button>
        </div>

        <template v-if="section === 'overview'">
          <div class="page-heading">
            <div>
              <p class="eyebrow">LIBRARY OPERATIONS</p>
              <h1>Good day, {{ user.name.split(' ')[0] }}.</h1>
              <p class="muted">Here’s what’s happening across your collection.</p>
            </div>
            <button
              v-if="isStaff"
              class="button button-primary"
              :disabled="!members.length || !availableBooks.length"
              @click="openModal('loan')"
            >
              <span class="button-plus">+</span> New checkout
            </button>
          </div>
          <div class="stats-grid">
            <article class="stat-panel stat-green">
              <div class="stat-label">
                <span>Titles in catalog</span><span class="stat-symbol">▤</span>
              </div>
              <strong>{{ books.length.toLocaleString() }}</strong
              ><small
                >Across
                {{ books.reduce((sum, book) => sum + book.total_copies, 0).toLocaleString() }} total
                copies</small
              >
            </article>
            <article class="stat-panel stat-yellow">
              <div class="stat-label">
                <span>Currently on loan</span><span class="stat-symbol">↗</span>
              </div>
              <strong>{{ activeLoans.length.toLocaleString() }}</strong
              ><small
                >{{
                  books.reduce((sum, book) => sum + book.available_copies, 0).toLocaleString()
                }}
                copies available</small
              >
            </article>
            <article class="stat-panel stat-rose">
              <div class="stat-label">
                <span>Overdue returns</span><span class="stat-symbol">!</span>
              </div>
              <strong>{{ overdueLoans.length.toLocaleString() }}</strong
              ><small>{{
                overdueLoans.length ? 'Needs follow-up' : 'All returns on schedule'
              }}</small>
            </article>
            <article class="stat-panel stat-blue">
              <div class="stat-label">
                <span>Registered members</span><span class="stat-symbol">◉</span>
              </div>
              <strong>{{ members.length.toLocaleString() }}</strong
              ><small>Active library accounts</small>
            </article>
          </div>
          <div class="overview-grid">
            <section class="content-section recent-section">
              <div class="section-heading">
                <div>
                  <p class="eyebrow">THE CIRCULATION DESK</p>
                  <h2>Recent activity</h2>
                </div>
                <button class="text-button" @click="section = 'loans'">
                  View circulation <span>→</span>
                </button>
              </div>
              <div v-if="loans.length" class="activity-list">
                <article v-for="loan in loans.slice(0, 5)" :key="loan.id" class="activity-row">
                  <span
                    :class="['activity-icon', loan.returned_at ? 'returned-icon' : 'loaned-icon']"
                    >{{ loan.returned_at ? '✓' : '↗' }}</span
                  >
                  <div class="activity-copy">
                    <strong>{{ loan.member }}</strong
                    ><span
                      >{{ loan.returned_at ? 'returned' : 'borrowed' }}
                      <b>{{ loan.title }}</b></span
                    >
                  </div>
                  <span
                    :class="[
                      'loan-state',
                      loan.returned_at
                        ? 'state-returned'
                        : isOverdue(loan)
                          ? 'state-overdue'
                          : 'state-active',
                    ]"
                    >{{
                      loan.returned_at ? 'Returned' : isOverdue(loan) ? 'Overdue' : 'On loan'
                    }}</span
                  >
                  <time>{{ formatDate(loan.returned_at || loan.borrowed_at) }}</time>
                </article>
              </div>
              <div v-else class="empty-state">
                <span class="empty-mark">↗</span><strong>No circulation activity yet</strong>
                <p>New checkouts will appear here.</p>
              </div>
            </section>
            <aside class="quick-panel">
              <p class="eyebrow">QUICK ACTIONS</p>
              <h2>At the desk</h2>
              <p class="muted">Common tasks, ready when you are.</p>
              <button v-if="isStaff" class="quick-action" @click="openModal('loan')">
                <span class="quick-icon quick-coral">↗</span
                ><span><strong>Check out a book</strong><small>Record a new loan</small></span
                ><span class="quick-arrow">→</span>
              </button>
              <button v-if="isStaff" class="quick-action" @click="openModal('book')">
                <span class="quick-icon quick-lime">＋</span
                ><span><strong>Add to collection</strong><small>Create a catalog entry</small></span
                ><span class="quick-arrow">→</span>
              </button>
              <button v-if="isStaff" class="quick-action" @click="openModal('member')">
                <span class="quick-icon quick-blue">◉</span
                ><span
                  ><strong>Register a member</strong><small>Set up a library account</small></span
                ><span class="quick-arrow">→</span>
              </button>
              <div class="desk-note">
                <span>“</span>
                <p>A library is not a luxury but one of the necessities of life.</p>
                <small>HENRY WARD BEECHER</small>
              </div>
            </aside>
          </div>
        </template>

        <template v-else-if="section === 'catalog'">
          <div class="page-heading">
            <div>
              <p class="eyebrow">COLLECTION SERVICES</p>
              <h1>Book catalog</h1>
              <p class="muted">Browse and maintain the library collection.</p>
            </div>
            <button v-if="isStaff" class="button button-primary" @click="openModal('book')">
              <span class="button-plus">+</span> Add a book
            </button>
          </div>
          <section class="content-section table-section">
            <div class="table-toolbar">
              <div class="table-summary">
                <strong>{{ filteredBooks.length }} titles</strong><span>·</span
                ><span
                  >{{ books.reduce((sum, book) => sum + book.available_copies, 0) }} copies
                  available</span
                >
              </div>
              <label class="search-field"
                ><span>⌕</span
                ><input
                  v-model="search"
                  placeholder="Search titles, authors, ISBN…"
                  aria-label="Search catalog"
                /><kbd>⌘ K</kbd></label
              >
            </div>
            <div class="table-scroll">
              <table>
                <thead>
                  <tr>
                    <th>BOOK</th>
                    <th>ISBN</th>
                    <th>CATEGORY</th>
                    <th>AVAILABILITY</th>
                    <th>STATUS</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="book in filteredBooks" :key="book.id">
                    <td>
                      <div class="book-cell">
                        <span class="book-cover">{{ book.title.charAt(0).toUpperCase() }}</span
                        ><span
                          ><strong>{{ book.title }}</strong
                          ><small>{{ book.author }}</small></span
                        >
                      </div>
                    </td>
                    <td class="code-cell">{{ book.isbn || '—' }}</td>
                    <td>{{ book.category || 'General' }}</td>
                    <td>
                      <strong>{{ book.available_copies }}</strong
                      ><span class="subtle"> / {{ book.total_copies }} copies</span>
                    </td>
                    <td>
                      <span
                        :class="[
                          'availability',
                          book.available_copies ? 'available' : 'unavailable',
                        ]"
                        ><i></i>{{ book.available_copies ? 'Available' : 'All on loan' }}</span
                      >
                    </td>
                  </tr>
                  <tr v-if="!filteredBooks.length">
                    <td colspan="5">
                      <div class="table-empty">
                        {{
                          search ? 'No titles match this search.' : 'No books have been added yet.'
                        }}
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>
        </template>

        <template v-else-if="section === 'loans'">
          <div class="page-heading">
            <div>
              <p class="eyebrow">LENDING & RETURNS</p>
              <h1>Circulation</h1>
              <p class="muted">Track checkouts, due dates, and returned books.</p>
            </div>
            <button
              v-if="isStaff"
              class="button button-primary"
              :disabled="!members.length || !availableBooks.length"
              @click="openModal('loan')"
            >
              <span class="button-plus">+</span> New checkout
            </button>
          </div>
          <div class="circulation-strip">
            <div>
              <span class="mini-dot dot-green"></span><strong>{{ activeLoans.length }}</strong
              ><span>active loans</span>
            </div>
            <div>
              <span class="mini-dot dot-red"></span><strong>{{ overdueLoans.length }}</strong
              ><span>past due</span>
            </div>
            <div>
              <span class="mini-dot dot-blue"></span
              ><strong>{{ loans.filter((loan) => loan.returned_at).length }}</strong
              ><span>returned</span>
            </div>
          </div>
          <section class="content-section table-section">
            <div class="table-toolbar">
              <div class="table-summary">
                <strong>Loan register</strong><span>·</span><span>{{ loans.length }} records</span>
              </div>
              <label class="search-field"
                ><span>⌕</span
                ><input
                  v-model="search"
                  placeholder="Search member or title…"
                  aria-label="Search loans"
              /></label>
            </div>
            <div class="table-scroll">
              <table>
                <thead>
                  <tr>
                    <th>MEMBER & TITLE</th>
                    <th>CHECKED OUT</th>
                    <th>DUE DATE</th>
                    <th>STATUS</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="loan in filteredLoans" :key="loan.id">
                    <td>
                      <div class="loan-person">
                        <span class="member-monogram">{{
                          loan.member.charAt(0).toUpperCase()
                        }}</span
                        ><span
                          ><strong>{{ loan.member }}</strong
                          ><small>{{ loan.title }}</small></span
                        >
                      </div>
                    </td>
                    <td>{{ formatDate(loan.borrowed_at) }}</td>
                    <td>{{ formatDate(loan.due_at) }}</td>
                    <td>
                      <span
                        :class="[
                          'loan-state',
                          loan.returned_at
                            ? 'state-returned'
                            : isOverdue(loan)
                              ? 'state-overdue'
                              : 'state-active',
                        ]"
                        >{{
                          loan.returned_at ? 'Returned' : isOverdue(loan) ? 'Overdue' : 'On loan'
                        }}</span
                      >
                    </td>
                    <td>
                      <button
                        v-if="isStaff && !loan.returned_at"
                        class="button button-quiet button-small"
                        :disabled="busy"
                        @click="returnBook(loan)"
                      >
                        Check in
                      </button>
                    </td>
                  </tr>
                  <tr v-if="!filteredLoans.length">
                    <td colspan="5">
                      <div class="table-empty">No matching circulation records.</div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>
        </template>

        <template v-else>
          <div class="page-heading">
            <div>
              <p class="eyebrow">CPSU COMMUNITY</p>
              <h1>Members</h1>
              <p class="muted">Manage registered library accounts.</p>
            </div>
            <button class="button button-primary" @click="openModal('member')">
              <span class="button-plus">+</span> Add member
            </button>
          </div>
          <section class="content-section table-section">
            <div class="table-toolbar">
              <div class="table-summary">
                <strong>{{ filteredMembers.length }} members</strong><span>·</span
                ><span>Registered accounts</span>
              </div>
              <label class="search-field"
                ><span>⌕</span
                ><input
                  v-model="search"
                  placeholder="Search name or email…"
                  aria-label="Search members"
              /></label>
            </div>
            <div class="table-scroll">
              <table>
                <thead>
                  <tr>
                    <th>MEMBER</th>
                    <th>EMAIL ADDRESS</th>
                    <th>ACCOUNT</th>
                    <th>ACTIVE LOANS</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="member in filteredMembers" :key="member.id">
                    <td>
                      <div class="loan-person">
                        <span class="member-monogram">{{
                          member.name.charAt(0).toUpperCase()
                        }}</span
                        ><strong>{{ member.name }}</strong>
                      </div>
                    </td>
                    <td>{{ member.email }}</td>
                    <td>
                      <span class="availability available"><i></i>Active</span>
                    </td>
                    <td>{{ activeLoans.filter((loan) => loan.member_id === member.id).length }}</td>
                  </tr>
                  <tr v-if="!filteredMembers.length">
                    <td colspan="4">
                      <div class="table-empty">
                        {{ search ? 'No members match this search.' : 'No member accounts yet.' }}
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>
        </template>
      </section>
    </div>

    <div v-if="modal" class="modal-backdrop" @click.self="modal = null">
      <section
        class="modal-card"
        role="dialog"
        aria-modal="true"
        :aria-labelledby="`${modal}-modal-title`"
      >
        <button class="modal-close" aria-label="Close dialog" @click="modal = null">×</button>
        <p class="eyebrow">
          {{
            modal === 'book'
              ? 'COLLECTION SERVICES'
              : modal === 'member'
                ? 'COMMUNITY ACCESS'
                : 'LENDING DESK'
          }}
        </p>
        <h2 :id="`${modal}-modal-title`">
          {{
            modal === 'book'
              ? 'Add a book'
              : modal === 'member'
                ? 'Register a member'
                : 'New checkout'
          }}
        </h2>
        <p class="muted">
          {{
            modal === 'book'
              ? 'Add a title and its copy count to the catalog.'
              : modal === 'member'
                ? 'Create a member account for the CPSU community.'
                : 'Choose a member and an available title.'
          }}
        </p>
        <form v-if="modal === 'book'" class="stack-form modal-form" @submit.prevent="createBook">
          <label
            >Book title<input
              v-model="bookForm.title"
              maxlength="200"
              required
              placeholder="e.g. The Philippine Islands"
          /></label>
          <label
            >Author<input
              v-model="bookForm.author"
              maxlength="200"
              required
              placeholder="Author name"
          /></label>
          <div class="form-row">
            <label
              >ISBN <span class="optional">Optional</span
              ><input v-model="bookForm.isbn" maxlength="30" placeholder="978…" /></label
            ><label
              >Category<input
                v-model="bookForm.category"
                maxlength="100"
                placeholder="History, Science…"
            /></label>
          </div>
          <label
            >Number of copies<input
              v-model.number="bookForm.total_copies"
              type="number"
              min="0"
              max="100000"
              required
          /></label>
          <button class="button button-primary button-wide" :disabled="busy" type="submit">
            {{ busy ? 'Adding…' : 'Add to catalog' }}
          </button>
        </form>
        <form
          v-else-if="modal === 'member'"
          class="stack-form modal-form"
          @submit.prevent="createMember"
        >
          <label
            >Full name<input
              v-model="memberForm.name"
              maxlength="200"
              autocomplete="name"
              required
              placeholder="Member’s full name"
          /></label>
          <label
            >Email address<input
              v-model="memberForm.email"
              type="email"
              maxlength="254"
              autocomplete="email"
              required
              placeholder="name@cpsu.edu.ph"
          /></label>
          <label
            >Temporary password<input
              v-model="memberForm.password"
              type="password"
              minlength="12"
              maxlength="256"
              required
              placeholder="At least 12 characters"
          /></label>
          <p class="form-hint">
            Share the temporary password securely. Members can use it to sign in.
          </p>
          <button class="button button-primary button-wide" :disabled="busy" type="submit">
            {{ busy ? 'Creating…' : 'Create member account' }}
          </button>
        </form>
        <form v-else class="stack-form modal-form" @submit.prevent="createLoan">
          <label
            >Member<select v-model="loanForm.member_id" required>
              <option value="" disabled>Select a member</option>
              <option v-for="member in members" :key="member.id" :value="String(member.id)">
                {{ member.name }} · {{ member.email }}
              </option>
            </select></label
          >
          <label
            >Book<select v-model="loanForm.book_id" required>
              <option value="" disabled>Select an available title</option>
              <option v-for="book in availableBooks" :key="book.id" :value="String(book.id)">
                {{ book.title }} ({{ book.available_copies }} available)
              </option>
            </select></label
          >
          <label
            >Loan period<select v-model.number="loanForm.days">
              <option :value="7">7 days</option>
              <option :value="14">14 days</option>
              <option :value="21">21 days</option>
              <option :value="30">30 days</option>
            </select></label
          >
          <button
            class="button button-primary button-wide"
            :disabled="busy || !members.length || !availableBooks.length"
            type="submit"
          >
            {{ busy ? 'Recording…' : 'Confirm checkout' }}
          </button>
          <p v-if="!members.length || !availableBooks.length" class="form-hint">
            {{
              !members.length
                ? 'Register a member before checking out a book.'
                : 'There are no available copies to check out.'
            }}
          </p>
        </form>
      </section>
    </div>
  </div>
</template>
