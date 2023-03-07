# Access Control in Rails

<small>**Topics Covered:** Authentication, Authorisation, CanCanCan, Devise</small><br><br>

In this worksheet you will secure a Rails application. We will use the Devise gem to verify the identity of users using usernames and passwords (authentication). We will then use the CanCanCan gem to control what parts of the application a user can access (authorisation).

Devise and CanCanCan have detailed documentation, which can be found here:
* https://github.com/heartcombo/devise
* https://github.com/CanCanCommunity/cancancan

If you have difficulties please refer to the material on https://learn.shefcompsci.org.uk, the Rails guides at https://guides.rubyonrails.org/v7.0/, or ask for help.

## Preparation
Use your code from the previous worksheet or alternatively check out the solution from:
```
git@git.shefcompsci.org.uk:com3420-2022-23/materials/access-control-in-rails.git
```

Then run the following commands to setup the project:
```
cd access-control-in-rails
bin/setup
```
You can then run
```
bundle exec rails s
```
and in a second terminal or tab
```
bin/webpacker-dev-server
```
to start up the application. You can now visit http://localhost:3000 to see your application running.

## Authentication with Devise

Devise is installed as a gem. This is already installed for you in the worksheet example and template app. You can see this in the Gemfile as:

```
gem 'devise'
```

Before we can use Devise, we need to create a new model for storing information about our users. By convention, this is usually called the User model. We will use Devise to create it and populate some default settings for us.

Run the following command:

```
bundle exec rails generate devise user
```

This will create a `User` model (`app/models/user.rb`) and add an extra line to your application's routes (`config/routes.rb`) to handle the user log in/out/registration pages.

We can add some additional fields to help track details about each user. Open the `db/migrate/{timestamp}_devise_create_users.rb` file. You will need to uncomment the lines for the trackable fields so that your file looks like below:

```
## Trackable
t.integer  :sign_in_count, default: 0, null: false
t.datetime :current_sign_in_at
t.datetime :last_sign_in_at
t.string   :current_sign_in_ip
t.string   :last_sign_in_ip
```

The database now needs to be migrated to add the users table (Devise has generated the migration to do this) by running:

```
bundle exec rails db:migrate
```

Take a look at the user model file (`app/models/user.rb`). At the top of it, there is call to the `devise` method, and a number of symbols following it:

```
devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable
```

This method call is used to configure Devise for this model. Currently it tells Devise that this particular model should have a number of Devise modules available to it:

* :database_authenticatable tells Devise that this model is authenticated using the database (more in the next section)
* :registerable tells Devise that a user can register themselves from the log in page
* :recoverable tells Devise to offer the 'forgot your password' functionality
* :rememberable tells Devise that the user can tick a 'remember me' box and be automatically logged into the application
* :validatable tells Devise to provide some default validations for user-provided information like email address, password length, etc.

Lets add :trackable into the list of modules to allow us to track the time and ip address of users logging into the system. Your devise method call in `app/models/user.rb` should now look like this:

```
devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       :trackable
```

## Task 1 - Seed the first user

Add the following to the seeds file (db/seeds.rb), replacing the email address and password with your own details. We advise using a dummy password for the purposes of this exercise, as it may later be stored in version control:

```
User.where(email:'my.email.address@sheffield.ac.uk').first_or_create(password:'Password123', password_confirmation:'Password123')
```

The seed file is a script that can be run to populate a database, and is useful for creating the first user so you can log into your application (which may then provide functionality to add further users). The line above queries the database for a user with the given email address and either returns the user if they exist (first) or creates a new user with the given parameters. The reason we use first_or_create in a seed file and not just create is to avoid duplicate entries in the database if the seed file is run more than once.

Run the seed file using the following command:

```
bundle exec rails db:seed
```

## Task 2 - Require authentication

Even though Devise is now installed, it is not currently protecting your application. If you visit your application in a browser, you will notice that you can access all of the pages without being required to log in.

Devise makes use of a controller method called `before_action` - if you have looked at controllers created using the scaffold generator, you will see a `before_action` that is used to retrieve the model for the relevant controller. `before_action` tells Rails to perform something before an action is called.

Add the following near the other `before_action` lines in `application_controller.rb`:

```
before_action :authenticate_user!
```

If you now try to access your application's home page at http://localhost:3000 you will be redirected to the log in page.

`authenticate_user!` is a Devise method that checks whether or not a user has logged into the application, and if not it redirects them to log in.

By default, the above `before_action` will intercept any action within the controller. This may not be desirable. For example, you want to allow unauthenticated users access to the landing page, but prevent them creating or modifying existing products or categories. In this case, you can add `skip_before_action` to `app/controllers/pages_controller.rb`

```
skip_before_action :authenticate_user!, only: [:home]
```

This will stop `authenticate_user!` being called for the `home` action in the `PagesController`


Alternatively, you may only wish to protect certain pages. For example:

```
before_action :authenticate_user!, only: [:new, :create]
```

This will prevent unauthenticated users accessing the new or create actions, but they will still be able to edit or view the index list.

Note that `before_action` currently applies to all controllers in the application (because we have added it to application_controller). If you want to enforce different requirements on specific controllers in your application, you can use `skip_before_action` or you can add the `before_action` to each controller as you require. See [Action Controller Rails Guide - Filters](https://guides.rubyonrails.org/v7.0/action_controller_overview.html#filters) for more information.

## Task 3 - Display the current user and a log out link

Devise does not automatically update your application to present information about the currently logged in user or allow them to perform other Devise actions, such as logging out. However, it does provide some methods that allow you to do this yourself:

* `current_user` gives you access to the current user who is logged into Devise. You can then access properties like username or email address.
* `user_signed_in?` returns true or false, depending on whether or not someone is currently logged into Devise.
* `destroy_user_session_path` returns the path used by Devise to log the user out, and this should be used to provide a log out link to the user.

Note: Links to `destroy_user_session_path` need to use the `:delete` method. The logout menu item would normally look like this:

```
= link_to destroy_user_session_path, method: :delete, class: 'nav-link' do
  Logout
```

We can edit the application's layout file [app/views/layouts/application.html.haml](app/views/layouts/application.html.haml) to use these methods. Copy an existing menu item and update it to link to `destroy_user_session_path` with the text 'Logout'. Your code should check `user_signed_in?` before generating this new sign out menu item. Lastly add a nav item that shows the current users email address, e.g.:

```
.navbar-text= current_user.email
```

Now the layout determines if a user is logged into Devise, and displays some content based on the outcome of that check. If they are logged in, their email address is displayed with a link to log out. Make sure you start your application and can login with the email address and password you specified in the seeds file. Lastly check your logout link works.

If you are required to authenticate University of Sheffield users for your team project please read the 'Authenticating University Users' guide under the 'Additional Material' heading on https://learn.shefcompsci.org.uk.

# Authorisation with CanCanCan

It is often the case that only certain types of users are allowed to perform certain actions in an application. The mechanism behind controlling this behaviour is called authorisation.

For example, let's say that we have two types of user that can log into the backend of our shop; there is an 'employee' who can only edit product details, and a 'manager' who can add new products, delete them, manage categories, and so on.

Let's create a migration to add a Boolean field to User to represent whether a user is only an employee, or whether they are also a manager:

Run this command:

```
bundle exec rails generate migration add_manager_to_users
```

Add this to the generated migration file within the change method:

```
add_column :users, :manager, :boolean, default: false
```

Now we need to update the database with our new migration:

```
bundle exec rails db:migrate
```

In order to perform the authorisation, we could simply add code such as `if current_user.manager?` to all the places where we want the behaviour to be different for a manager. The problem with this approach is that as our application grows, it becomes increasingly difficult to keep track of these rules and changing them becomes risky and time-consuming.

## Abilities

To simplify authorisation we want to centralise our rules, and generalise our checks - the CanCanCan gem allows us to do this by defining what a user can do in an “Ability” file.

An ability translates directly to the name of an action in a controller (although you can define your own). The standard abilities for a model are:

* `:index`
* `:new`
* `:create`
* `:edit`
* `:update`
* `:destroy`
* `:show`
* `:read` (a shortcut for :index and :show together)
* `:manage` (a shortcut for all abilities, including any custom ones)

So, if you wanted to enable a user to edit and update a Product, you would declare this as:

```
can [:edit, :update], Product
```

## Task 4 - Configure CanCanCan

Open the `app/models/ability.rb` file in your application you should find it contains the following:

```
class Ability
  include CanCan::Ability

  def initialize(user)
    ... (some commented out text)
  end
end
```

Inside the `initialize` method is where you will declare abilities. The `user` variable will automatically be populated by the user that is currently logged in via Devise.

Let's add some authorisation to `categories_controller.rb`. Add `authorize_resource` as indicated below:

```
class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
...
```

The `authorize_resource` helper will check whether the current user is allowed to perform the requested action as defined in the `ability.rb` file. By default `authorize_resource` will look for an instance variable named after the controller it is in. So for the `categories_controller` you need to make sure the category you are loading is called `@category`. If you do not name the variable correctly then CanCanCan may let people access things that you do not want them to.

If you log into your application and go to http://localhost:3000/categories you will see that you are now unauthorised to access that page (403 – Access Denied).

Add an ability to `ability.rb` within the `initialize` method, to say that managers can access anything related to categories:

```
user ||= User.new
if user.manager?
  can :manage, Category
end
```

`user ||= User.new` will initialise a new user if there isn't one logged in, without saving it to the database.

This change will not have any effect yet, as we have not made our user into a manager.

## Task 5 - Hide content that cannot be accessed

You will notice that even though you currently cannot access categories you can still see the link on the menu bar. It is good practice to hide links that the user cannot access. CanCanCan provides us with a few helper methods to make this easy.

Open [app/views/layouts/application.html.haml](app/views/layouts/application.html.haml). You will see the lines that add the categories link to the menu bar. We can wrap these in a line of code that will only show it if the current user can see them:

```
- if can?(:read, Category)
  %li
    = link_to 'Categories', categories_path, title: 'Go to the categories page', class: 'nav-link px-2 link-secondary'
```

The `can?` method takes two arguments. The first is the action you want to check, and the second is what you want to check the action on. This can either be a class, or an instance of a model. If you have an instance of a model it is almost always better to use that, but for this top level menu we need to use the Category class.

For example:
* `can?(:read, Category)` – Returns true if the user can index and show any category.
* `can?(:edit, @product)` – Returns true if the user can edit the specific product stored in @product.

## Task 6 - Enable manager access
There are currently no users within your application that can access the categories functionality, as nobody has been given manager access.

You can do this via the Rails console. Run the following:

```
bundle exec rails c
```

This will drop you into a Rails console session connected to your development database. You can use this to set your user account to be a manager. You can find your account with `user = User.find_by(email: 'my.email.address@sheffield.ac.uk')` and you can then update it with `user.update(manager: true)`.

At this point, check that you can now access categories within your application.

## Task 7 - Implement permissions
Implement the following authorisations in your application. Make sure to hide any links that a user is unable to access using the `can?` helper.

For the purposes of this exercise we will assume that only authenticated (logged in) users can access any page other than the landing page (`pages#home`).

A non-manager user can only:
* View the list of categories
* Edit categories

A manager can:
* View / add / edit / delete products
* View / add / edit / delete categories
