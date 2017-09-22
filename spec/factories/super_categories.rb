# frozen_string_literal: true

FactoryGirl.define do
  factory :super_category do
    name { Faker::Commerce.department }
    image do
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAnElEQVR42u3RAQ0AAAgDIN8'\
    '/9K3hHFQg03Y4I0KEIEQIQoQgRAhChAgRghAhCBGCECEIEYIQhAhBiBCECEGIEIQgRAhChCBECEKEIAQhQhAiBCFCECIEIQgRghA'\
    'hCBGCECEIQYgQhAhBiBCECEEIQoQgRAhChCBECEIQIgQhQhAiBCFCEIIQIQgRghAhCBGCECFChCBECEKEIOS7BchtK0ieNE3rAAAAAElFTkSuQmCC'
    end
  end
end
