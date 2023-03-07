# README

This README would normally document whatever steps are necessary to get the
application up and running.

Run ‘bin/setup’ If  show something like “permission deny”,Run ‘sudo bin/setup’ 

See which database have not been migrated—>Run ‘sudo bin/rails db:migrate:status RAILS_ENV=development’

Database conflicts—> Run ‘rails destroy migration users’

                                         ‘rails destroy migration create_users’

                                               ‘rails destroy migration devise_create_users’

**Reason: Delete the conflicting database files and you can migrate**

Finally,Run ‘rails db:migrate’
