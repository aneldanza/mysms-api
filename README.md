# MySMS API

MySMS API is a backend application for managing SMS messages. It provides endpoints for user authentication, message creation, and real-time updates using ActionCable.

## Features

- User authentication with Devise and JWT.
- SMS message creation and status tracking.
- Real-time updates using WebSockets (ActionCable).
- MongoDB as the database for storing user and message data.

---

## Requirements

- **Ruby version**: `3.1.4`
- **Rails version**: `7.x`
- **MongoDB**: Ensure MongoDB is installed and running.

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/aneldanza/mysms-api.git
cd mysms-api
```

### 3. Configure the Database

Update the `config/mongoid.yml` file with your MongoDB connection details. For example:

```yaml
production:
  clients:
    default:
      uri: <%= ENV['MONGODB_URI'] %>
```

Ensure the `MONGODB_URI` environment variable is set correctly for your environment.

### 4. Set Environment Variables

Create a `.env` file in the root directory and add the following:

```yaml
TWILIO_ACCOUNT_SID=<TWILIO_ACCOUNT_SID>
TWILIO_AUTH_TOKEN=<TWILIO_AUTH_TOKEN>
TWILIO_TO_PHONE_NUMBER=<YOUR_FREE_TWILIO_TO_PHONE_NUMBER>
TWILIO_FROM_PHONE_NUMBER=<YOUR_FREE_TWILIO_FROM_PHONE_NUMBER>
BASE_URL=<YOUR_APP_URL>
MONGODB_URI=<MONGODB_URI>
REDIS_URL=<REDIS_URL>
```

### 5. Initialize the Database

Run the following command to seed the database:

```yaml
rails db:seed
```

### 6. Start the Server

Start the Rails server with:

The server will be available at http://localhost:3000.

```yaml
rails server
```

### 7. Running Tests

To run the test suite, use:

Ensure the test database is configured correctly in `config/mongoid.yml`.

### 8. Deployment

Set up a production MongoDB instance (e.g., MongoDB Atlas).
Configure the `MONGODB_URI` environment variable for production.
Deploy the app to your preferred hosting platform (e.g., Heroku, AWS, or Render).
