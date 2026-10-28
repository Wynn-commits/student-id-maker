import { ref, computed, type Ref, type ComputedRef } from 'vue'
import type { PersonProfile, Skill } from '@/types/portfolio'
import profileData from '@/data/profile.json'
import profileImage from '@/assets/ako.jpg'

export function usePortfolio(): {
  profile: Ref<PersonProfile>
  name: ComputedRef<string>
  role: ComputedRef<string>
  tagline: ComputedRef<string>
  image: ComputedRef<string>
  imageAlt: ComputedRef<string>
  skills: ComputedRef<Skill[]>
  contact: ComputedRef<PersonProfile['contact']>
  skillsByCategory: ComputedRef<Record<string, Skill[]>>
} {
  const profile = ref<PersonProfile>({
    ...(profileData as PersonProfile),
    image: profileImage,
  })

  const name = computed(() => profile.value.name)
  const role = computed(() => profile.value.role)
  const tagline = computed(() => profile.value.tagline)
  const image = computed(() => profile.value.image)
  const imageAlt = computed(() => profile.value.imageAlt)
  const skills = computed(() => profile.value.skills)
  const contact = computed(() => profile.value.contact)

  const skillsByCategory = computed<Record<string, Skill[]>>(() => {
    return skills.value.reduce<Record<string, Skill[]>>((acc, skill) => {
      const key = skill.category ?? 'uncategorized'
      ;(acc[key] ??= []).push(skill)
      return acc
    }, {})
  })

  return {
    profile,
    name,
    role,
    tagline,
    image,
    imageAlt,
    skills,
    contact,
    skillsByCategory,
  }
}
