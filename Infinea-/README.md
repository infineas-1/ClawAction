# InFinea – Local Dev Quickstart

## One-command start (front + backend)

```bash
cd Infinea-
chmod +x dev-up.sh
./dev-up.sh
```

This starts:
- Backend: `http://localhost:8001`
- Frontend: `http://localhost:3000`

## Required backend env file

Create `backend/.env` with at least:

```env
MONGO_URL=<your_mongo_connection_string>
DB_NAME=<your_db_name>
JWT_SECRET=<long_random_secret>
```

The backend now refuses to start if `JWT_SECRET` is missing or insecure.
