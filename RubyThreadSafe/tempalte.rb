h = {
  timeout: true,
  valid: false,
  redirection: nil,
  propagation: [
    {
      location: 'USA',
      matched: false,
      timeout: true
    }
  ],

  instruction: [
    registrar: 'Godady',
    content: 'Step 1:'
  ]
}

puts h.to_s
