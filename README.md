# 🔍 Search Analytics App

A real-time search input analytics app built with **Ruby on Rails 7** and **Vanilla JS**, created as part of the **Helpjuice Full-Stack Internship Test**.

This app captures and processes user search inputs in real-time, deduplicates incomplete queries, and displays analytics for each user session — all without using authentication.

---

## 🚀 Live Demo

👉 [Deployed on Heroku](https://search-analytics-00e725efaf89.herokuapp.com/)

---

## ⚙️ Features

- 🔎 Real-time search input tracking with debounce
- 🧠 Smart filtering to avoid the "pyramid problem"
- 📊 Per-user search analytics and top searches
- ⚡ Redis caching for scalability
- 🧪 RSpec test suite
- 🐳 Dockerized for consistent development

---

## 📦 Tech Stack

- **Backend**: Ruby on Rails 7
- **Frontend**: Vanilla JavaScript + TailwindCSS
- **Database**: PostgreSQL
- **Caching**: Redis
- **Tests**: RSpec, FactoryBot
- **Deployment**: Heroku
- **DevOps**: Docker, Docker Compose

---

## 🐳 Getting Started with Docker

To run the project locally using Docker:

```bash
docker-compose up
The app will be available at:

arduino
Copy
Edit
http://localhost:3000
Make sure ports 3000 and 6379 (Redis) are free on your local machine.

🧪 Running Tests
To run the RSpec test suite inside Docker:

bash
Copy
Edit
docker-compose run web bundle exec rspec
📄 Evaluation Criteria Covered
✅ Delivered within 48 hours
✅ Clean and well-documented code
✅ Tested with RSpec
✅ Deployed to Heroku
✅ Dockerized for easy local setup
✅ Solves pyramid problem using smart deduplication
✅ UI styled using Tailwind CSS
✅ Per-session tracking without login (via IP)

