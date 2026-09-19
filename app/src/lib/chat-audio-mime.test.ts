import { describe, expect, it } from 'vitest'
import { mimeAudioBase } from '@/lib/chat-audio-mime'

describe('mimeAudioBase', () => {
  it('quita codecs de webm opus (caso Chrome)', () => {
    expect(mimeAudioBase('audio/webm;codecs=opus')).toBe('audio/webm')
  })

  it('conserva audio/mp4 de Safari', () => {
    expect(mimeAudioBase('audio/mp4')).toBe('audio/mp4')
  })

  it('fallback a audio/webm si viene vacío', () => {
    expect(mimeAudioBase('')).toBe('audio/webm')
  })

  it('ignora tipos no-audio', () => {
    expect(mimeAudioBase('video/webm')).toBe('audio/webm')
  })
})
