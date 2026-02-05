# Sam Library API

A Rails 8 API-only application for managing a virtual library book catalog. This API supports JWT authentication and provides both public and private book listings.

## 🛠 Prerequisites

- **Ruby**: 3.3.5
- **Database**: PostgreSQL
- **Bundler**: `gem install bundler`

## 🚀 Getting Started

### 1. Clone & Install Dependencies
```bash
bundle install
```

### 2. Environment Configuration
Copy the example environment file and update the values (especially the database credentials and JWT secret):
```bash
cp .env.example .env
```

### 3. Database Setup
Ensure PostgreSQL is running, then run:
```bash
bin/rails db:prepare
```

### 4. Run the Server
```bash
bin/rails server
```
The API will be available at `http://localhost:3000`.

## 🧪 Development Tools

### Running Tests
```bash
bin/rails test
```

### Linting (RuboCop)
```bash
bin/rubocop
```

### Security Scan (Brakeman)
```bash
bin/brakeman --no-pager --no-exit-on-warn
```
