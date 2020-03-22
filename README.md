# Fire Ball
This is the API for the Fire Ball platform. The Fireball platform is an open source learning environment where learners are free to access classes free of charge at zero cost.

We believe that knowledge is free and should be accessible to anyone irrespective of how much they have. This platform not only aids in making learning free, we also hope to make learning as simple as possible so that users can grasp very complicated concepts easily.

### setup
* clone the repostiory
* create a new branch and checkout to that new branch
* create a **local_env.yml** in the **config** directory to store your enviromental    variables
* the **local_env.yml** file should have the following:  
    DB_NAME: database username  
    DB_PASSWORD: database password  
    AMAZON_API_KEY:amazone s3 api key  
    AMAZON_SECRET_KEY: amazone s3 secret key  
    BUCKET_NAME: amazone s3 bucket name  
    GMAIL_ADDRESS: email to be used for mailer function  
    GMAIL_PASSWORD: your gmail password

* Be sure to have configured your rails environment to use postgresql. [See postgresql setup for rails](https://www.digitalocean.com/community/tutorials/how-to-set-up-ruby-on-rails-with-postgres).
* Also setup redis on your device for caching and job queues, and make sure it's running
* Run the command **rails db:migraate** to migrate all the table in the databse
* Run **rails s** to serve your application on the default port 3000 or **rails s --port= new port** to specify a new port
* run sidekiq with the command **sidekiq -C config/sidekiq.yml**
* Be sure to be running rails 5.0 and above to use active storage
* push to your branch
* thank you

## contributor(s)
* Valentine Oragbakosi