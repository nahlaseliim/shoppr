# Shoppr 
A Flutter e-commerce app built with Provider as state management.

Uses the [Platzi Fake Store API](https://api.escuelajs.co/api/v1) for products and authentication.

## Screenshots
<img width="280" alt="Screenshot1" src="https://github.com/user-attachments/assets/d97bae44-90e2-40a6-bf67-77a625e71d64" />
<img width="280" alt="screenshot2" src="https://github.com/user-attachments/assets/a6bb2863-5d21-470a-b06f-bfc99c644773" />
<img width="280" alt="Screenshot3" src="https://github.com/user-attachments/assets/367ebf2f-666a-452c-94b6-47b116487c99" />
<img width="280" alt="Screenshot4" src="https://github.com/user-attachments/assets/3a0072a3-827a-4d35-a744-81e99bc6289c" />
<img width="280" alt="Screenshot5" src="https://github.com/user-attachments/assets/97237b02-8c02-4591-8930-fbaf6645f49c" />


## Features

- Register and login with email/password
- Token saved locally — stays logged in after closing the app
- Browse products in a grid
- Filter by category
- Add/remove items from cart with quantity controls
- Checkout with delivery address and phone number
- Order confirmation screen

---

## Tech stack

| Package | Purpose |
|---|---|
| `provider` | State management (auth + cart) |
| `dio` | HTTP requests |
| `shared_preferences` | Persist login token |
| `device_preview` | Preview on different screen sizes during development |

---

## Setup

```bash
# 1. Clone the repo
https://github.com/nahlaseliim/shoppr.git
cd shoppr

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

**Demo account:** `john@mail.com` / `changeme`

> Note: `device_preview` is only active in debug mode. It's automatically disabled in release builds.

---

## Project structure

```
lib/
├── main.dart
├── constants/
│   └── api_constants.dart
├── models/
│   ├── product.dart
│   ├── category.dart
│   └── cart_item.dart
├── state/
│   ├── auth_state.dart
│   └── cart_state.dart
├── services/
│   └── product_service.dart
├── screens/
│   ├── startup_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   └── confirmation_screen.dart
└── widgets/
    └── product_card.dart
```

---

## API

All data from [Platzi Fake Store API](https://api.escuelajs.co/api/v1):

| Endpoint | Usage |
|---|---|
| `POST /auth/login` | Login → returns access token |
| `POST /users` | Register new user |
| `GET /products` | Fetch all products |
| `GET /categories/{id}/products` | Filter by category |
| `GET /categories` | Fetch all categories |
