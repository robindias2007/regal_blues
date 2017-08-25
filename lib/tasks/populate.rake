# frozen_string_literal: true

namespace :db do
  desc 'Seed fake data'

  task populate: :environment do
    # Don't change the order
    create_all_categories
    create_designers
    create_products
    create_users
    create_requests
  end

  private

  def create_all_categories
    puts 'Creating categories'
    cat = Category.find_or_create_by(name: 'Women', image: 'Image URL',
      super_category: SuperCategory.find_or_create_by(name: 'Apparels', image: 'Image URL'))
    SubCategory.create!(sub_category_with(cat))
  end

  def sub_category_with(cat)
    [
      { name: 'Saree', image: 'Image URL', category: cat },
      { name: 'Lehenga', image: 'Image URL', category: cat },
      { name: 'Chudidar', image: 'Image URL', category: cat },
      { name: 'Anarkali', image: 'Image URL', category: cat },
      { name: 'Chunri', image: 'Image URL', category: cat },
      { name: 'Choli', image: 'Image URL', category: cat },
      { name: 'Mekhela Sador', image: 'Image URL', category: cat },
      { name: 'Mundum Neriyathum', image: 'Image URL', category: cat },
      { name: 'Pattu Pavadai', image: 'Image URL', category: cat },
      { name: 'Ghagra', image: 'Image URL', category: cat }
    ]
  end

  def create_designers
    puts 'Creating Designers'
    20.times do |i|
      designer = Designer.create!(designer_attrs)
      build_store_info_for designer
      build_finance_info_for designer
      associate_categories_for designer
      puts "Created Designer #{i + 1}"
    end
  end

  def designer_attrs
    {
      full_name: Faker::Name.name, email: Faker::Internet.email, password: 'password',
      mobile_number: '+' + [1, 49, 91].sample.to_s + Faker::Number.number(10),
      location: Faker::LordOfTheRings.location
    }
  end

  def build_store_info_for(designer)
    designer.build_designer_store_info(display_name: Faker::Company.name,
    registered_name: Faker::Company.name + Faker::Company.suffix, pincode: Faker::Number.number(6),
    country: Faker::Address.country, state: Faker::Address.state, city: Faker::Address.city,
    address_line_1: Faker::Address.street_address,
    contact_number: Faker::Number.number(10), min_order_price: Faker::Commerce.price,
    processing_time: Faker::Number.number(2))
  end

  def build_finance_info_for(designer)
    designer.build_designer_finance_info(bank_name: Faker::Bank.name, bank_branch: Faker::Address.city,
    ifsc_code: Faker::Bank.swift_bic, account_number: Faker::Number.number(10),
    blank_cheque_proof: 'Some url string', personal_pan_number: Faker::Company.australian_business_number,
    personal_pan_number_proof: 'Some url string', business_pan_number: Faker::Company.australian_business_number,
    business_pan_number_proof: 'Some url string', tin_number: Faker::Company.australian_business_number,
    tin_number_proof: 'Some url string', gstin_number: Faker::Company.australian_business_number,
    gstin_number_proof: 'Some url string', business_address_proof: 'Some url string')
  end

  def associate_categories_for(designer)
    3.times do
      designer.sub_categories << SubCategory.where.not(id: designer.sub_categories.pluck(:id)).sample
    end
  end

  def create_products
    puts 'Creating products'
    Designer.all.each do |designer|
      puts "Creating products for #{designer.full_name}"
      10.times do |i|
        puts "Creating product #{i + 1}"
        product = Product.create!(product_attrs(designer))
        create_info_for product
        puts "Created product #{i + 1}"
      end
    end
  end

  def product_attrs(designer)
    {
      name: Faker::Commerce.unique.product_name, description: Faker::Lorem.paragraph,
      selling_price: Faker::Commerce.price, designer: designer, sub_category: designer.sub_categories.sample
    }
  end

  def create_info_for(product)
    ProductInfo.create!(color: Faker::Color.color_name, fabric: Faker::Lorem.words.join(', '),
    care: Faker::Lorem.words(5).join(', '), notes: Faker::Lorem.words(10).join(', '),
    work: Faker::Lorem.words.join(', '), product: product)
  end

  def create_users
    puts 'Creating Users'
    50.times do |i|
      puts "Creating User #{i + 1}"
      user = User.create!(user_attrs)
      user.mark_as_confirmed!
      puts 'User created'
    end
  end

  def user_attrs
    {
      full_name:     Faker::Name.name,
      username:      Faker::Internet.user_name(Faker::Internet.user_name(4..40), '_'),
      mobile_number: '+' + [1, 49, 91].sample.to_s + Faker::Number.number(10),
      gender:        Faker::Demographic.sex.downcase,
      email:         Faker::Internet.email,
      password:      'password'
    }
  end

  def create_requests
    User.all.each do |user|
      puts "Creating requests for #{user.username}"
      (1..5).to_a.sample.times do
        req = Request.create!(request_attrs(user))
        associate_designers_to req
      end
    end
  end

  def request_attrs(user)
    min = Faker::Commerce.price
    size = %w[xs-s s-m m-l l-xl xl-xxl].sample
    {
      name: Faker::Commerce.unique.product_name, size: size,
      min_budget: min, max_budget: 1.8 * min, timeline: Faker::Number.between(1, 10),
      description: Faker::Lorem.paragraph, user: user, sub_category: SubCategory.all.sample,
      images_attributes: [{ image: 'Image URL', width: 10, height: 10 }, { image: 'Image URL', width: 10, height: 10 }]
    }
  end

  def associate_designers_to(req)
    (1..10).to_a.sample.times do |i|
      designer = Designer.where.not(id: req.request_designers.pluck(:designer_id)).sample
      puts "#{i + 1}: Associating #{designer.full_name} to a request #{req.name}"
      req.request_designers.create!(designer: designer)
    end
  end
end
