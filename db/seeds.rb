# frozen_string_literal: true

require "securerandom"

APPOINTMENT_STATUS = Appointment.statuses.symbolize_keys.freeze
ENROLLMENT_STATUS = Enrollment.statuses.symbolize_keys.freeze
INVOICE_STATUS = Invoice.statuses.symbolize_keys.freeze
REPORT_CARD_STATUS = ReportCard.statuses.symbolize_keys.freeze

now = Time.current.change(min: 0, sec: 0)

puts "Seeding service types..."
service_types = [
  { name: "Private Training", price: 75, duration_minutes: 60, capacity: 1, description: "One-on-one training session tailored to the dog and owner." },
  { name: "Group Class", price: 30, duration_minutes: 90, capacity: 6, description: "Small group class with socialization and obedience focus." },
  { name: "Board & Train", price: 150, duration_minutes: 24 * 60, capacity: 2, description: "Daily rate for immersive training with boarding." }
].to_h do |attrs|
  record = ServiceType.find_or_initialize_by(name: attrs[:name])
  record.update!(attrs.merge(active: true))
  [attrs[:name], record]
end

puts "Seeding clients..."
clients = [
  { first_name: "Alex", last_name: "Johnson", email: "alex.johnson@example.com", phone: "555-1000", address: "101 Maple St, Springfield", notes: "Prefers evening sessions." },
  { first_name: "Brianna", last_name: "Lee", email: "brianna.lee@example.com", phone: "555-2000", address: "202 Oak Ave, Springfield", notes: "Has two active dogs." },
  { first_name: "Carlos", last_name: "Mendes", email: "carlos.mendes@example.com", phone: "555-3000", address: "303 Pine Rd, Springfield", notes: "Enjoys group classes." },
  { first_name: "Dana", last_name: "Patel", email: "dana.patel@example.com", phone: "555-4000", address: "404 Birch Blvd, Springfield", notes: "Wants confidence building." },
  { first_name: "Ethan", last_name: "Rivers", email: "ethan.rivers@example.com", phone: "555-5000", address: "505 Cedar Ln, Springfield", notes: "Travels often, likes board & train." }
].to_h do |attrs|
  record = Client.find_or_initialize_by(email: attrs[:email])
  record.update!(attrs)
  [attrs[:email], record]
end

puts "Seeding dogs..."
dogs = [
  { client: clients["alex.johnson@example.com"], name: "Luna", sex: "female", breed: "Border Collie", temperament: "High energy, very smart", training_goals: "Advanced obedience", training_history: "Basic obedience complete", weight: 32.5 },
  { client: clients["alex.johnson@example.com"], name: "Rocky", sex: "male", breed: "Boxer", temperament: "Friendly, distractible", training_goals: "Loose leash walking", training_history: "Puppy kindergarten", weight: 55.0 },
  { client: clients["alex.johnson@example.com"], name: "Bella", sex: "female", breed: "Beagle", temperament: "Curious, scent-driven", training_goals: "Recall reliability", training_history: "Basic cues", weight: 28.0 },
  { client: clients["brianna.lee@example.com"], name: "Milo", sex: "male", breed: "Labrador Retriever", temperament: "Eager to please", training_goals: "Impulse control", training_history: "House trained", weight: 65.0 },
  { client: clients["brianna.lee@example.com"], name: "Daisy", sex: "female", breed: "Cocker Spaniel", temperament: "Gentle, shy", training_goals: "Confidence building", training_history: "None", weight: 24.0 },
  { client: clients["carlos.mendes@example.com"], name: "Cooper", sex: "male", breed: "Australian Shepherd", temperament: "Work-driven", training_goals: "Herding cues", training_history: "Basic obedience", weight: 48.0 },
  { client: clients["carlos.mendes@example.com"], name: "Nala", sex: "female", breed: "Mixed", temperament: "Sociable", training_goals: "Group manners", training_history: "Some group classes", weight: 42.0 },
  { client: clients["dana.patel@example.com"], name: "Zeus", sex: "male", breed: "German Shepherd", temperament: "Confident, protective", training_goals: "Reactivity management", training_history: "Protection training basics", weight: 78.0 },
  { client: clients["dana.patel@example.com"], name: "Maple", sex: "female", breed: "Golden Retriever", temperament: "Affectionate", training_goals: "Therapy prep", training_history: "CGC practice", weight: 62.0 },
  { client: clients["ethan.rivers@example.com"], name: "Finn", sex: "male", breed: "Corgi", temperament: "Playful", training_goals: "Agility foundations", training_history: "Beginner agility", weight: 30.0 },
  { client: clients["ethan.rivers@example.com"], name: "Poppy", sex: "female", breed: "Mini Poodle", temperament: "Smart, vocal", training_goals: "Quiet on cue", training_history: "Basic tricks", weight: 14.0 }
].to_h do |attrs|
  owner = attrs.fetch(:client)
  dog_attrs = attrs.except(:client)
  record = Dog.find_or_initialize_by(name: dog_attrs[:name], client: owner)
  record.update!(dog_attrs.merge(client: owner))
  [record.name, record]
end

puts "Seeding appointments..."
appointments_data = [
  { seed_id: "seed-appt-01", client: clients["alex.johnson@example.com"], dog: dogs["Luna"], service_type: service_types["Private Training"], days_offset: -10, hour: 10, status: :completed, trainer_notes: "Great focus on heeling drills." },
  { seed_id: "seed-appt-02", client: clients["alex.johnson@example.com"], dog: dogs["Rocky"], service_type: service_types["Private Training"], days_offset: -7, hour: 18, status: :completed, trainer_notes: "Improved leash manners." },
  { seed_id: "seed-appt-03", client: clients["alex.johnson@example.com"], dog: dogs["Bella"], service_type: service_types["Private Training"], days_offset: -3, hour: 17, status: :scheduled, trainer_notes: "Introduce long-line recall." },
  { seed_id: "seed-appt-04", client: clients["brianna.lee@example.com"], dog: dogs["Milo"], service_type: service_types["Private Training"], days_offset: -15, hour: 9, status: :completed, trainer_notes: "Impulse control games." },
  { seed_id: "seed-appt-05", client: clients["brianna.lee@example.com"], dog: dogs["Daisy"], service_type: service_types["Private Training"], days_offset: -2, hour: 11, status: :cancelled, trainer_notes: "Client had conflict." },
  { seed_id: "seed-appt-06", client: clients["brianna.lee@example.com"], dog: dogs["Milo"], service_type: service_types["Group Class"], days_offset: -5, hour: 13, status: :completed, trainer_notes: "Worked on group sit-stay.", dog_participates: true },
  { seed_id: "seed-appt-07", client: clients["carlos.mendes@example.com"], dog: nil, service_type: service_types["Group Class"], days_offset: 3, hour: 18, status: :scheduled, trainer_notes: "Evening manners class.", dog_participates: false },
  { seed_id: "seed-appt-08", client: clients["carlos.mendes@example.com"], dog: dogs["Cooper"], service_type: service_types["Private Training"], days_offset: -20, hour: 15, status: :completed, trainer_notes: "Herding focus cues." },
  { seed_id: "seed-appt-09", client: clients["carlos.mendes@example.com"], dog: dogs["Nala"], service_type: service_types["Private Training"], days_offset: -12, hour: 16, status: :no_show, trainer_notes: "Client missed session." },
  { seed_id: "seed-appt-10", client: clients["dana.patel@example.com"], dog: dogs["Zeus"], service_type: service_types["Private Training"], days_offset: -8, hour: 14, status: :completed, trainer_notes: "Reactivity drills with decoys." },
  { seed_id: "seed-appt-11", client: clients["dana.patel@example.com"], dog: dogs["Maple"], service_type: service_types["Private Training"], days_offset: -1, hour: 9, status: :scheduled, trainer_notes: "Therapy dog prep." },
  { seed_id: "seed-appt-12", client: clients["dana.patel@example.com"], dog: dogs["Zeus"], service_type: service_types["Group Class"], days_offset: -4, hour: 19, status: :completed, trainer_notes: "Neutral dog exposures.", dog_participates: true },
  { seed_id: "seed-appt-13", client: clients["ethan.rivers@example.com"], dog: dogs["Finn"], service_type: service_types["Private Training"], days_offset: -6, hour: 8, status: :completed, trainer_notes: "Agility foundations." },
  { seed_id: "seed-appt-14", client: clients["ethan.rivers@example.com"], dog: dogs["Poppy"], service_type: service_types["Private Training"], days_offset: 5, hour: 12, status: :scheduled, trainer_notes: "Quiet cue practice." },
  { seed_id: "seed-appt-15", client: clients["ethan.rivers@example.com"], dog: dogs["Finn"], service_type: service_types["Board & Train"], days_offset: -14, hour: 8, status: :completed, trainer_notes: "Three-day board & train.", duration_override: 3.days },
  { seed_id: "seed-appt-16", client: clients["alex.johnson@example.com"], dog: dogs["Luna"], service_type: service_types["Board & Train"], days_offset: 7, hour: 8, status: :scheduled, trainer_notes: "Weekend board & train.", duration_override: 2.days },
  { seed_id: "seed-appt-17", client: clients["brianna.lee@example.com"], dog: dogs["Milo"], service_type: service_types["Private Training"], days_offset: 10, hour: 17, status: :scheduled, trainer_notes: "Proofing cues outdoors." },
  { seed_id: "seed-appt-18", client: clients["carlos.mendes@example.com"], dog: dogs["Cooper"], service_type: service_types["Private Training"], days_offset: -25, hour: 10, status: :completed, trainer_notes: "Early foundation session." },
  { seed_id: "seed-appt-19", client: clients["dana.patel@example.com"], dog: dogs["Zeus"], service_type: service_types["Private Training"], days_offset: -18, hour: 18, status: :completed, trainer_notes: "Leash handling refresh." },
  { seed_id: "seed-appt-20", client: clients["ethan.rivers@example.com"], dog: dogs["Poppy"], service_type: service_types["Group Class"], days_offset: 12, hour: 11, status: :scheduled, trainer_notes: "Puppy socialization.", dog_participates: true }
]

appointments = appointments_data.to_h do |attrs|
  starts_at = now + attrs[:days_offset].days + attrs[:hour].hours
  duration = attrs[:duration_override] || attrs[:service_type].duration_minutes.minutes
  record = Appointment.find_or_initialize_by(series_id: attrs[:seed_id])
  record.update!(
    client: attrs[:client],
    dog: attrs[:dog],
    service_type: attrs[:service_type],
    starts_at: starts_at,
    ends_at: starts_at + duration,
    status: APPOINTMENT_STATUS.fetch(attrs[:status]),
    notes: attrs[:notes],
    trainer_notes: attrs[:trainer_notes]
  )
  [attrs[:seed_id], record]
end

puts "Seeding group enrollments..."
group_enrollments = [
  { appointment: appointments["seed-appt-07"], dogs: %w[Cooper Nala Milo Daisy], status: :active },
  { appointment: appointments["seed-appt-12"], dogs: %w[Zeus Nala Finn], status: :active },
  { appointment: appointments["seed-appt-06"], dogs: %w[Milo Daisy], status: :active },
  { appointment: appointments["seed-appt-20"], dogs: %w[Poppy Finn Maple], status: :active }
]

group_enrollments.each do |entry|
  entry[:dogs].each_with_index do |dog_name, idx|
    dog = dogs[dog_name]
    next unless dog && entry[:appointment]

    enrollment = Enrollment.find_or_initialize_by(appointment_id: entry[:appointment].id, dog_id: dog.id)
    enrollment.update!(
      status: ENROLLMENT_STATUS.fetch(entry[:status]),
      waitlist_position: entry[:appointment].service_type.capacity < idx + 1 ? idx + 1 : nil
    )
  end
end

puts "Seeding invoices and line items..."
invoice_definitions = [
  { number: "INV-2025-001", client: clients["alex.johnson@example.com"], status: :draft, issue_date: now.to_date - 5, due_date: now.to_date + 5, appointments: %w[seed-appt-03], notes: "Draft for upcoming session." },
  { number: "INV-2025-002", client: clients["brianna.lee@example.com"], status: :sent, issue_date: now.to_date - 8, due_date: now.to_date - 1, appointments: %w[seed-appt-06], notes: "Group class package." },
  { number: "INV-2025-003", client: clients["carlos.mendes@example.com"], status: :paid, issue_date: now.to_date - 20, due_date: now.to_date - 10, appointments: %w[seed-appt-08 seed-appt-18], notes: "Two herding sessions." },
  { number: "INV-2025-004", client: clients["dana.patel@example.com"], status: :overdue, issue_date: now.to_date - 15, due_date: now.to_date - 3, appointments: %w[seed-appt-10], notes: "Reactivity training overdue." },
  { number: "INV-2025-005", client: clients["ethan.rivers@example.com"], status: :sent, issue_date: now.to_date - 2, due_date: now.to_date + 7, appointments: %w[seed-appt-13], notes: "Agility foundations follow-up." }
]

invoice_records = invoice_definitions.to_h do |inv|
  invoice = Invoice.find_or_initialize_by(invoice_number: inv[:number])

  line_items = inv[:appointments].map do |appt_id|
    appt = appointments[appt_id]
    {
      description: "#{appt.service_type.name} - #{appt&.dog&.name || 'Group'}",
      unit_price: appt.service_type.price,
      quantity: appt.service_type.name == "Board & Train" ? ((appt.ends_at - appt.starts_at) / 1.day).round : 1,
      appointment: appt
    }
  end

  subtotal = line_items.sum { |item| item[:unit_price].to_d * item[:quantity] }
  tax = (subtotal * BigDecimal("0.07")).round(2)
  total = (subtotal + tax).round(2)

  invoice.assign_attributes(
    client: inv[:client],
    issue_date: inv[:issue_date],
    due_date: inv[:due_date],
    notes: inv[:notes],
    status: INVOICE_STATUS.fetch(inv[:status]),
    subtotal: subtotal,
    tax: tax,
    total: total,
    sent_at: [:sent, :paid, :overdue].include?(inv[:status]) ? inv[:issue_date].to_time + 6.hours : nil,
    paid_at: inv[:status] == :paid ? inv[:due_date].to_time - 1.day : nil
  )
  invoice.save!

  line_items.each do |item|
    ili = InvoiceLineItem.find_or_initialize_by(invoice_id: invoice.id, description: item[:description])
    ili.update!(
      appointment: item[:appointment],
      unit_price: item[:unit_price],
      quantity: item[:quantity],
      total: (item[:unit_price].to_d * item[:quantity]).round(2)
    )
  end

  [inv[:number], invoice]
end

puts "Seeding report cards..."
completed_appointments = appointments.values.select(&:completed?).first(10)

score_profiles = [
  {
    overall_score: 9,
    obedience_score: 9,
    leash_manners_score: 8,
    focus_score: 9,
    socialization_score: 8,
    strengths: "Excellent focus and reliable cues.",
    areas_for_improvement: "Maintain impulse control near wildlife.",
    homework: "Three 5-minute advanced obedience drills daily.",
    trainer_notes: "Ready to proof in busier locations."
  },
  {
    overall_score: 7,
    obedience_score: 7,
    leash_manners_score: 6,
    focus_score: 7,
    socialization_score: 7,
    strengths: "Solid basics and quick recovery after distractions.",
    areas_for_improvement: "Looser leash around other dogs.",
    homework: "Figure-eight heel patterns with left/right turns.",
    trainer_notes: "Reinforce consistent release cues."
  },
  {
    overall_score: 5,
    obedience_score: 5,
    leash_manners_score: 5,
    focus_score: 5,
    socialization_score: 6,
    strengths: "Engages well with food rewards.",
    areas_for_improvement: "Responds slowly when overstimulated.",
    homework: "Two-minute settle on a mat twice daily.",
    trainer_notes: "Keep sessions under 10 minutes to prevent shutdown."
  },
  {
    overall_score: 3,
    obedience_score: 3,
    leash_manners_score: 2,
    focus_score: 3,
    socialization_score: 4,
    strengths: "Comfortable with handler touch and gear.",
    areas_for_improvement: "Leash pulling and startle response to traffic.",
    homework: "Desensitization to city sounds from a safe distance.",
    trainer_notes: "Use higher-value rewards outdoors."
  },
  {
    overall_score: 10,
    obedience_score: 10,
    leash_manners_score: 10,
    focus_score: 10,
    socialization_score: 9,
    strengths: "Polished performance across all skills.",
    areas_for_improvement: "Generalize to new environments.",
    homework: "Field trip to a hardware store for novelty.",
    trainer_notes: "Great communication between handler and dog."
  },
  {
    overall_score: 6,
    obedience_score: 6,
    leash_manners_score: 7,
    focus_score: 6,
    socialization_score: 5,
    strengths: "Responsive to marker words.",
    areas_for_improvement: "Falls out of position on figure eights.",
    homework: "Half-step pace changes during heelwork.",
    trainer_notes: "Alternate food and praise to keep engagement."
  },
  {
    overall_score: 4,
    obedience_score: 4,
    leash_manners_score: 3,
    focus_score: 4,
    socialization_score: 5,
    strengths: "Comfortable around training equipment.",
    areas_for_improvement: "Breaks stay when handler steps away.",
    homework: "Place command with five-second increments.",
    trainer_notes: "Keep criteria small and build gradually."
  },
  {
    overall_score: 2,
    obedience_score: 2,
    leash_manners_score: 2,
    focus_score: 2,
    socialization_score: 3,
    strengths: "Takes treats softly and checks in with handler.",
    areas_for_improvement: "High reactivity to bicycles.",
    homework: "LAT around bikes starting at 20 feet.",
    trainer_notes: "End sessions before reaching threshold."
  },
  {
    overall_score: 8,
    obedience_score: 8,
    leash_manners_score: 7,
    focus_score: 8,
    socialization_score: 8,
    strengths: "Great engagement once warmed up.",
    areas_for_improvement: "Needs faster sits on recall.",
    homework: "Speed drills with chase-to-recall games.",
    trainer_notes: "Mix play breaks between reps."
  },
  {
    overall_score: 1,
    obedience_score: 1,
    leash_manners_score: 1,
    focus_score: 1,
    socialization_score: 2,
    strengths: "Beginning to build trust with handler.",
    areas_for_improvement: "Overwhelmed in new spaces.",
    homework: "One-minute decompression walks each hour.",
    trainer_notes: "Prioritize safety and distance; keep exits open."
  }
]

report_cards_data = completed_appointments.each_with_index.map do |appt, idx|
  scores = score_profiles[idx % score_profiles.length]

  {
    appointment: appt,
    dog: appt.dog,
    overall_score: scores[:overall_score],
    obedience_score: scores[:obedience_score],
    leash_manners_score: scores[:leash_manners_score],
    focus_score: scores[:focus_score],
    socialization_score: scores[:socialization_score],
    report_date: appt.ends_at.to_date,
    strengths: scores[:strengths],
    areas_for_improvement: scores[:areas_for_improvement],
    homework: scores[:homework],
    trainer_notes: scores[:trainer_notes],
    share_token: "rc-token-#{idx + 1}"
  }
end

report_cards_data.each do |attrs|
  rc = ReportCard.find_or_initialize_by(share_token: attrs[:share_token])
  rc.update!(attrs.merge(status: REPORT_CARD_STATUS[:published]))
end

puts "Seeding media consents..."
media_consent_data = [
  { client: clients["alex.johnson@example.com"], marketing_allowed: true, social_media_allowed: true, website_allowed: true, internal_only: false, notes: "Happy to share progress clips." },
  { client: clients["brianna.lee@example.com"], marketing_allowed: true, social_media_allowed: true, website_allowed: false, internal_only: false, notes: "No last names on posts." },
  { client: clients["carlos.mendes@example.com"], marketing_allowed: true, social_media_allowed: false, website_allowed: true, internal_only: false, notes: "Website gallery only." },
  { client: clients["ethan.rivers@example.com"], marketing_allowed: false, social_media_allowed: false, website_allowed: false, internal_only: true, notes: "No external sharing." }
]

media_consent_data.each do |attrs|
  consent = MediaConsent.find_or_initialize_by(client: attrs[:client])
  consent.update!(
    marketing_allowed: attrs[:marketing_allowed],
    social_media_allowed: attrs[:social_media_allowed],
    website_allowed: attrs[:website_allowed],
    internal_only: attrs[:internal_only],
    notes: attrs[:notes],
    consented_at: attrs[:marketing_allowed] ? now - 2.days : nil
  )
end

puts "Seed data loaded successfully."
