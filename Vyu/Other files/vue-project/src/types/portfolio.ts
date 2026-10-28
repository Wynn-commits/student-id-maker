/**
 * Shared TypeScript types for the portfolio application.
 * Centralizing types here keeps components lean and improves maintainability.
 */
export interface ContactInfo {
  email: string
  github: string
  linkedin: string
}

export interface Skill {
  name: string
  /** Optional URL to filter by category or proficiency */
  category?: 'frontend' | 'backend' | 'tools'
  level?: 1 | 2 | 3 | 4 | 5
}

export interface PersonProfile {
  name: string
  role: string
  tagline: string
  image: string
  imageAlt: string
  skills: Skill[]
  contact: ContactInfo
}
