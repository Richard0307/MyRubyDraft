# Getting started

## Additional configuration
This template has most configuration set up already to work with our servers. There are however a few additional tweaks you need to make specific to your project.

### Sentry config
Before you start your group project, you will get an invitation to set up an account on Sentry ([https://sentry.shefcompsci.org.uk/](https://sentry.shefcompsci.org.uk/)). Sentry is a tool we use to collect errors from your application when it is is deployed to a non-development environment - if any errors occur on your site, you will get an email notification about it.

Once you have set up the account, you will have access to a pre-created team project. Within your project settings, you will be given a `DSN` (very similar to a website URL). You will need to replace the `REPLACE_WITH_YOUR_DSN` part in `config/initializers/sentry.rb` with this URL.

### Deployment config
When you are ready to deploy your application to QA or demo, you need to update some deployment configuration for your team. This can be found on the info site: [https://info.shefcompsci.org.uk/](https://info.shefcompsci.org.uk/).

For deployment to the DEMO environment, you will need to replace `DEMO_SERVER` and `DEMO_USER` in `config/deploy/demo.rb` with the ones provided on the info page, and also replace `PUT_APP_URL_HERE` in `config/environments/demo.rb` with the URL of your DEMO site.

### Email config
Before you can send out emails from your application, you will need to add the following config to your `config/application.rb`, inside the `class Application < Rails::Application ... end` block:
```
config.action_mailer.smtp_settings = {
  address:              'mailhost.shef.ac.uk',
  port:                 587,
  enable_starttls_auto: true,
  openssl_verify_mode:  OpenSSL::SSL::VERIFY_PEER,
  openssl_verify_depth: 3,
  ca_file:              '/etc/ssl/certs/ca-certificates.crt'
}
```

You will also need to configure the `from:` setting in your mailers to `no-reply@sheffield.ac.uk`.

On your local machine, we use a gem called `letter_opener`, which is already installed an configured in this template, and instead of sending out an email, the application will open up a tab in your browser, allowing you to view the content of the email.

On QA and demo server, if you do not wish the emails to be sent to the actual recipients, you can use the gem `sanitize_email` to redirect these emails to your team. The gem is already included in the template, and you can find out more about how to configure it on their GitHub page: [https://github.com/pboling/sanitize_email](https://github.com/pboling/sanitize_email)

## Styling your application
We use `shakapacker` gem to manage static assets in this template, which is a Rails wrapper for the Javascript library `webpack`.

You can find out more about `shakapacker` on their GitHub page: [https://github.com/shakacode/shakapacker](https://github.com/shakacode/shakapacker).

### Add custom JS
Additional Javascript files should be added to the `app/packs/scripts` directory, e.g. `app/packs/scripts/landing_page.js`. Then the file must be added to the entrypoint file `app/packs/entrypoints/application.js`, e.g.:
```
import '../scripts/landing_page.js'
```

### Installing additional JS libraries
Any JS libraries hosted on NPM can be installed with yarn. For example to install jQuery, run the following command:
```
yarn add jquery
```

Then in the file you would like to use jQuery (e.g. `app/packs/scripts/landing_page.js`), add:
```
import 'jquery';
```

Alternatively, if you wish to make jQuery globally available throughout your project, add the following to `app/packs/entrypoints/application.js`:
```
import $ from 'jquery';
window.$ = $;
```

### Add custom CSS
Additional stylesheets should be added to the `app/packs/styles` directory in `scss` format, e.g. `app/packs/styles/landing_page.scss`. Then the file must be added to the entrypoint file `app/packs/entrypoints/styles.js`, e.g.:
```
import '../styles/landing_page';
```

### Add images
Images should be added to `app/packs/images`, e.g. `app/packs/images/logo.png`. Then to include the image in your view, use the `image_pack_tag` helper, e.g.:
```
= image_pack_tag 'logo.png', height: 40
```
Please note that you **do not need to** include the `images/` path when using this helper.

Alternatively, to use an image in your CSS, use the `url` function, e.g. in your `app/packs/styles/layout.scss`, add:
```
body {
  background-image: url(images/logo.png);
}
```
Please note that you **need to** include the `images/` path when referring an image in CSS.
