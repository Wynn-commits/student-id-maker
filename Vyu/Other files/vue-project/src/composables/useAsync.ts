import { ref, type Ref } from 'vue'

export function useAsync() {
  const data = ref<unknown>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function run<T>(task: () => Promise<T>): Promise<T | undefined> {
    loading.value = true
    error.value = null
    try {
      const result = await task()
      data.value = result
      return result
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Something went wrong'
      return undefined
    } finally {
      loading.value = false
    }
  }

  return { data, loading, error, run }
}
