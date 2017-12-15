# frozen_string_literal: true

namespace :db do
  desc 'Seed fake data'

  task populate: :environment do
    # Don't change the order
    create_all_categories
    # create_designers
    # create_products
    # create_users
    # create_addresses_for_users
    # create_requests
    # create_offers
    # create_orders
  end

  private

  def create_all_categories
    puts 'Creating categories'
    cat = Category.find_or_create_by(name: 'Women', image: image_data,
      super_category: SuperCategory.find_or_create_by(name: 'Apparels', image: image_data))
    SubCategory.create!(sub_category_with(cat))
  end

  def sub_category_with(cat)
    [
      { name: 'Saree', image: image_data, category: cat },
      { name: 'Lehenga', image: image_data, category: cat },
      { name: 'Chudidar', image: image_data, category: cat },
      { name: 'Anarkali', image: image_data, category: cat },
      { name: 'Chunri', image: image_data, category: cat },
      { name: 'Choli', image: image_data, category: cat },
      { name: 'Mekhela Sador', image: image_data, category: cat },
      { name: 'Mundum Neriyathum', image: image_data, category: cat },
      { name: 'Pattu Pavadai', image: image_data, category: cat },
      { name: 'Ghagra', image: image_data, category: cat }
    ]
  end

  def create_designers
    puts 'Creating Designers'
    20.times do |i|
      designer = Designer.create!(designer_attrs(i))
      build_store_info_for designer
      build_finance_info_for designer
      associate_categories_for designer
      puts "Created designer #{i + 1}"
    end
  end

  def designer_attrs(i)
    {
      full_name: names[i], email: Faker::Internet.unique.email, password: 'password',
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
    processing_time: Faker::Number.number(2)).save!
  end

  def build_finance_info_for(designer)
    designer.build_designer_finance_info(bank_name: Faker::Bank.name, bank_branch: Faker::Address.city,
    ifsc_code: Faker::Bank.swift_bic, account_number: Faker::Number.number(10),
    blank_cheque_proof: 'Some url string', personal_pan_number: Faker::Company.australian_business_number,
    personal_pan_number_proof: 'Some url string', business_pan_number: Faker::Company.australian_business_number,
    business_pan_number_proof: 'Some url string', tin_number: Faker::Company.australian_business_number,
    tin_number_proof: 'Some url string', gstin_number: Faker::Company.australian_business_number,
    gstin_number_proof: 'Some url string', business_address_proof: 'Some url string').save!
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
      10.times do
        product = Product.create!(product_attrs(designer))
        attach_images_for product
        create_info_for product
      end
    end
  end

  def product_attrs(designer)
    {
      name: Faker::Commerce.unique.product_name, description: Faker::Lorem.paragraph,
      selling_price: Faker::Commerce.price + 100, designer: designer, sub_category: designer.sub_categories.sample
    }
  end

  def attach_images_for(product)
    Image.create!(image: image_data, imageable: product)
  end

  def create_info_for(product)
    ProductInfo.create!(color: Faker::Color.color_name, fabric: Faker::Lorem.words.join(', '),
    care: Faker::Lorem.words(5).join(', '), notes: Faker::Lorem.words(10).join(', '),
    work: Faker::Lorem.words.join(', '), product: product)
  end

  def create_users
    puts 'Creating Users'
    20.times do |i|
      puts "Creating User #{i + 1}"
      user = User.create!(user_attrs(i))
      user.mark_as_confirmed!
      puts 'User created'
    end
  end

  def user_attrs(i)
    {
      full_name:     names[i],
      username:      Faker::Internet.user_name(Faker::Internet.user_name(4..40), '_'),
      mobile_number: '+' + [1, 49, 91].sample.to_s + Faker::Number.number(10),
      gender:        Faker::Demographic.sex.downcase,
      email:         Faker::Internet.unique.email,
      password:      'password'
    }
  end

  def create_addresses_for_users
    puts 'Creating addresses for users'
    User.all.each do |user|
      (1..5).to_a.sample.times do
        user.addresses.create!(address_params)
      end
    end
  end

  def address_params
    {
     country:        Faker::Address.country,
     pincode:        Faker::Address.zip,
     street_address: Faker::Address.secondary_address + Faker::Address.street_address,
     landmark:       Faker::Address.community,
     city:           Faker::Address.city,
     state:          Faker::Address.state,
     nickname:       %w[home work other].sample
     }
  end

  def create_requests
    User.all.each do |user|
      puts "Creating requests for #{user.username}"
      (1..5).to_a.sample.times do
        Request.create!(request_attrs(user))
        # associate_designers_to req
      end
    end
  end

  def request_attrs(user)
    min = Faker::Commerce.price
    size = %w[xs-s s-m m-l l-xl xl-xxl].sample
    designers = Designer.all.sample(2)
    {
      name: Faker::Commerce.unique.product_name, size: size,
      min_budget: min, max_budget: 1.8 * min, timeline: Faker::Number.between(1, 6),
      description: Faker::Lorem.paragraph, user: user, sub_category: SubCategory.all.sample,
      address: user.addresses.sample,
      request_images_attributes: [
        { image: image_data, width: 10, height: 10, serial_number: 1 },
        { image: image_data, width: 10, height: 10, serial_number: 2 }
      ],
      request_designers_attributes: [{ designer_id: designers.first.id }, { designer_id: designers.second.id }]
    }
  end

  # def associate_designers_to(req)
  #   (1..10).to_a.sample.times do
  #     designer = Designer.where.not(id: req.request_designers.pluck(:designer_id)).sample
  #     req.request_designers.create!(designer: designer)
  #   end
  # end

  def create_offers
    requests = RequestDesigner.all
    count = requests.size
    puts "Creating #{count} offers"
    requests.sample(count / 2).each do |rd|
      Offer.create!(designer_id: rd.designer_id, request_id: rd.request_id)
    end
    puts 'Offers created'
    create_offer_quotations
  end

  def create_offer_quotations
    puts 'Creating Offer Quotations'
    Offer.all.each do |offer|
      (1..3).to_a.sample.times do
        OfferQuotation.create!(price: Faker::Commerce.price, description: Faker::Lorem.paragraph, offer: offer)
      end
    end
    puts 'Created Offer Quotations'
    create_oq_galleries_and_oq_measurements
  end

  def create_oq_galleries_and_oq_measurements
    puts 'Creating Offer Quotation Galleries'
    OfferQuotation.all.each do |oq|
      oqg = oq.offer_quotation_galleries.build(oqg_params)
      om = oq.offer_measurements.build(om_params)
      oqg.save
      om.save
    end
    puts 'Created Offer Quotation Galleries with measurements'
  end

  def om_params
    {
      data: {
        tags: %w[arms legs neck shoulder]
      }
    }
  end

  def oqg_params
    {
      name:              Faker::Name.first_name,
      images_attributes: Array.new(4) { { image: image_data, description: 'Some description' } }
    }
  end

  def create_orders
    puts 'Creating Orders'
    Offer.all.map do |offer|
      order = Order.new
      order.user = offer.request.user
      order.offer_quotation = offer.offer_quotations.first
      order.designer = offer.designer
      order.status = Order.aasm.states.map(&:name).sample
      order.save!
    end
  end

  def image_data
    data = Base64.encode64(File.read(Rails.root.join('spec', 'fixtures', 'request_images', "#{rand(1..10)}.jpg")))
    'data:image/jpeg;base64,' + data
  end

  def names
    ['Prasanna Jain', 'Shresth Banerjee', 'Jitender Pilla', 'Bhudev Talwar', 'Chandramohan Acharya III',
     'Baala Kaur', 'Rajinder Rana', 'Anuja Patil', 'Dev Kocchar', 'Giriraj Prajapat',
     'Anilabh Bandopadhyay', 'Chaaruchandra Nambeesan', 'Ekaksh Varma', 'Chapal Mishra',
     'Balaaditya Deshpande', 'Mrs. Chandira Tandon', 'Balgopal Asan PhD', 'Ekaksh Gowda',
     'Akshat Pothuvaal IV', 'Chandani Reddy']
  end
end
