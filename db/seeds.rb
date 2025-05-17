require 'faker'

puts "Xoá dữ liệu cũ..."
Note.delete_all
Topic.delete_all

puts "Tạo 100 topic..."
topics = 10000.times.map do
  Topic.create!(
    name: Faker::Book.genre
  )
end

puts "Tạo 1000 note..."
100000.times do
  Note.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    content: Faker::Lorem.paragraph(sentence_count: 5),
    topic: topics.sample
  )
end

puts "Hoàn tất seed dữ liệu!"
