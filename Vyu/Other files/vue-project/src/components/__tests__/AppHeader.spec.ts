import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import AppHeader from '@/components/AppHeader.vue'

describe('AppHeader', () => {
  it('renders the brand name and navigation links', () => {
    const wrapper = mount(AppHeader)

    expect(wrapper.get('h1').text()).toContain('Erwin Orquillano')

    const labels = wrapper.findAll('a').map((link) => link.text())
    expect(labels).toContain('About')
    expect(labels).toContain('Skills')
    expect(labels).toContain('Contact')
  })

  it('has correct anchor hrefs for section navigation', () => {
    const wrapper = mount(AppHeader)
    const hrefs = wrapper.findAll('a').map((link) => link.attributes('href'))
    expect(hrefs).toEqual(
      expect.arrayContaining(['#about', '#skills', '#contact']),
    )
  })
})
