# NiceForm

A nice form object for Rails that makes sense.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add nice_form

You might want to create an application-wide form:

```ruby
class ApplicationForm < NiceForm::Base; end
```

Or configure the default primary key settings if you're using something other than `id`:

```ruby
NiceForm.configure do |config|
  #                     name,  type 
  config.primary_key = [:uuid, :string]
end
```

You can also set this on a form-by-form basis.

## Usage

It's just like Active Model, but with some nice-to-haves.

### Basic usage 

Treat it like an Active Model object:

```ruby
class PostForm < NiceForm::Base
  self.acts_like = :post 
  
  attribute :subject
  attribute :context, :text
  attribute :published_at, :datetime
  attribute :requires_review, :boolean
end
```

```ruby
class PostsController < ApplicationController
  def new
    @form = PostForm.new 
  end
end
```

### From params

```ruby
class PostsController < ApplicationController
  def create
    @form = PostForm.new(post_params)
  end
  
  private 
  
  def post_params
    params.require(:post).permit(:subject, :content, :published_at, :requires_review)
  end
end
```

### From a model

```ruby
class PostsController < ApplicationController
  def edit
    post = Post.find(params[:id])
    @form = PostForm.from_model(post) # { id: 1, subject: "hello" ... }
  end
end
```

#### Map additional attributes to a form object

```ruby
class PostsController < ApplicationController
  def edit
    post = Post.find(params[:id])
    @form = PostForm.from_model(post)
  end
end
```

```ruby
class PostForm < NiceForm::Base
  self.acts_like = :post 
  
  attribute :subject
  attribute :context, :text
  attribute :published_at, :datetime
  attribute :requires_review, :boolean
  
  def map_model(model)
    model.requires_review = model.reviews.last.status == 'review'
  end
end
```

### Change the param key

```ruby
Rails.application.routes.draw do 
  resources :posts, param_name: :uuid
end
```

```ruby
class PostsController < ApplicationController
  def edit
    post = Post.find(params[:uuid])
    @form = PostForm.from_model(post)
  end
end
```

```ruby
class PostForm < NiceForm::Base
  self.acts_like = :post 
  
  self.primary_key :uuid, :string
  
  # ... 
end
```

## Validations

Again, just like an Active Model object:

```ruby
class PostForm < NiceForm::Base
  self.acts_like = :post 
  
  attribute :subject
  
  validates :subject, presence: true 
end
```

## External context

```ruby
class PostsController < ApplicationController
  def new
    @form = PostForm.new.with_context(user: current_staff_user)
  end
end
```

```ruby
class PostForm < NiceForm::Base
  self.acts_like = :post 
  
  attribute :category_id, :integer
  attribute :subject
  attribute :context, :text
  attribute :published_at, :datetime
  
  validates :category_id, with: :ensure_category_id!
  
  private 
  
  def ensure_category_id!
    unless CategoryUser.where(category_id: category_id, user: context[:user]).exists?
      self.errors.add(:category_id, "is invalid")
      throw(:abort)
    end
  end
end
```
