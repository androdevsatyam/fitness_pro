# Flutter web CI/CD with Firebase Hosting

## What is prepared

`.github/workflows/flutter-web.yml` runs on pull requests to `main`, pushes to `main`, and manual dispatches. It installs Flutter 3.35.1, resolves the committed lockfile, runs analysis and tests, builds the release web app, and retains a downloadable web artifact for 7 days.

Informational analyzer lints are visible but non-blocking. Errors, warnings, failed tests and failed builds prevent deployment. Deployment downloads exactly the tested artifact instead of rebuilding it.

Firebase deployment is skipped until the `FIREBASE_PROJECT_ID` repository variable is configured. Once configured, successful pushes to `main` deploy automatically. For manual runs, check the deploy input; deployment only accepts the `main` branch. Pull requests cannot deploy the live site and do not receive deployment credentials.

## One-time Firebase setup

1. Create or select a Firebase project in the Firebase console. Use **Hosting**, which supports static Flutter web output. Keep the Spark plan for a strictly free pilot.
2. Set up its default Hosting site. Firebase supplies `PROJECT_ID.web.app` and `PROJECT_ID.firebaseapp.com` addresses with HTTPS; buying a domain is optional.
3. Use the official Firebase CLI GitHub setup (`firebase init hosting:github`) to generate an account with Hosting deployment permissions and securely store its credential in GitHub. Keep this repository's existing workflow and `firebase.json`; do not replace them with the generated JavaScript-oriented build steps. Do not send credential JSON in chat or commit it.
4. In GitHub repository **Settings → Secrets and variables → Actions**, store the generated credential JSON in a secret named `FIREBASE_SERVICE_ACCOUNT`. The CLI normally chooses a project-specific secret name; use that value under this workflow's expected name, or update the workflow to reference the generated name.
5. Set the repository Actions variable `FIREBASE_PROJECT_ID` to the actual Firebase project ID, after the secret is ready.
6. Create the `firebase-production` GitHub environment if desired and add any required deployment reviewers. Credentials may instead be stored as a secret in that environment.
7. Push to `main`, or run **Flutter web CI and Firebase CD** manually from `main` with the deploy checkbox selected.

No Firebase project, credentials, billing changes, or live deployment are created by these local configuration files. Your Firebase project ID is still needed to complete the setup.

## Local deploy after setup

```sh
flutter pub get --enforce-lockfile
flutter test
flutter build web --release
firebase login
firebase deploy --only hosting --project YOUR_PROJECT_ID
```

`firebase.json` serves `build/web`, supports SPA route fallback and prevents stale app entry scripts. No Firebase client SDK is needed merely to host this static app.

## Free Hosting allowance

Checked against Firebase documentation on 24 October 2026:

- Hosting storage: **10 GB total**, including retained releases; not a fresh allocation every month.
- Transfer: the Hosting quota guide states **10 GB/month**. The pricing table displays **360 MB/day**. Monitor the Firebase console because these two official pages express the allowance differently.
- Free Firebase domains and HTTPS; no domain purchase needed.
- Spark needs no payment method. After exceeding the monthly transfer quota, Hosting can be disabled following a grace period until the next month. Exceeding storage blocks new releases until you remove old releases or upgrade.

Hosting quota covers static delivery only. SMS authentication, backend services, a purchased domain, and GitHub Actions usage have separate limits or charges. The second deployment target has not been specified yet, so no Android/iOS/backend publishing workflow is assumed.

References: [Hosting quotas](https://firebase.google.com/docs/hosting/usage-quotas-pricing), [Firebase pricing](https://firebase.google.com/pricing), [GitHub integration](https://firebase.google.com/docs/hosting/github-integration).
