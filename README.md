# 🏫 NSS CONNECT

**A Blockchain-Powered Event & Volunteer Management System for NSS Units**

## 📱 Overview

**NSS CONNECT** is a mobile application built to streamline and enhance the management of National Service Scheme (NSS) activities at Geethanjali College of Engineering and Technology. The app enables students, volunteers, and coordinators to interact via a unified platform that facilitates:

- Real-time event updates and registration
- Volunteer participation tracking
- Blockchain-based certificate issuance
- Transparent fundraising through crowdfunding modules

## ✨ Key Features

- 📅 **Event Management:** Volunteers can view and register for upcoming NSS events, drives, and workshops.
- 🔐 **Blockchain Integration:** All participation records, certificates, and donation transactions are securely logged using Ethereum smart contracts.
- 🎓 **Digital Certificates:** Automatically issue tamper-proof certificates to volunteers.
- 💰 **Crowdfunding Module:** Enable secure and transparent fundraising for NSS causes.
- 🔔 **Real-Time Notifications:** Keep users informed about new events and campaign progress.
- 📊 **Admin Dashboard:** Coordinators can manage events, monitor funds, and validate participation.

## 🔧 Tech Stack

| Layer        | Technology       |
|--------------|------------------|
| Frontend     | Flutter           |
| Backend      | Node.js, Express |
| Database     | MongoDB          |
| Blockchain   | Ethereum (Solidity, Web3.js, Truffle) |
| Smart Contract Standards | ERC-721 (NFT for certificates) |
| UI Design    | Material Design  |

## 🧪 Testing

The project includes comprehensive testing across:

- Unit Testing
- Integration Testing
- System Testing

Test cases include event registration, blockchain transactions, and certificate validation.

## 🔒 Security Measures

- End-to-end encryption
- Role-based access control
- Immutable blockchain records for participation and fundraising
- Secure authentication

## 🎯 Objectives

- Improve transparency via blockchain
- Automate and simplify administrative tasks
- Increase student engagement
- Ensure data security and scalability

## 🧱 System Architecture

The app architecture includes four primary components:

- **Volunteer Interface**: Mobile interface for event registration, donation, and certificate access.
- **Coordinator Interface**: Admin dashboard to manage events and fundraisers.
- **Backend Server**: Handles authentication, data processing, and smart contract triggers.
- **Blockchain Layer**: Ethereum-based smart contracts for secure data logging.

## 🔗 Smart Contracts

Implemented smart contracts include:

- `EventManager.sol`: Handles event creation and volunteer registration.
- `CertificateNFT.sol`: Issues digital NFT-based certificates.
- `NSSConnect.sol`: Manages events, funds, and certificates in one integrated contract.

## 📸 Screenshots

Screens for registration, login, event page, donations, payment, profile, and certificate generation are provided in the `/screenshots/` folder (to be added).

## 📁 Project Structure

```
📦 nss-connect
├── 📂 contracts        # Solidity smart contracts
├── 📂 frontend         # Flutter frontend app
├── 📂 backend          # Node.js & Express backend
├── 📂 test             # Truffle test scripts
├── 📂 scripts          # Deployment scripts
├── 📄 README.md
└── 📄 package.json
```

## 🚀 Deployment Instructions

1. **Start Ganache** (local blockchain simulator):

```bash
npm run start-ganache
```

2. **Compile & Deploy Contracts**

```bash
truffle compile
truffle migrate
```

3. **Run Backend Server**

```bash
cd backend
npm install
npm start
```

4. **Launch Flutter App**

```bash
cd frontend
flutter pub get
flutter run
```

## 🔮 Future Enhancements

- AI Chatbot for user support
- Real-time analytics dashboard for coordinators
- Integration with QR code for certificate verification
- Feedback and rating system for events

## 👨‍💻 Authors

- **A. Shriya** (21R11A05A7)  
- **A. Sai Srujana** (21R11A05A8)  
- **S. Chandu** (21R11A05E6)

## 📜 License

This project is developed for academic purposes and may be adapted under an open-source license based on institutional permission.
