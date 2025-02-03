# FluxKey
A decentralized key management solution built on Stacks blockchain using Clarity.

## Overview
FluxKey enables secure key management with the following features:
- Create and store encrypted keys
- Grant and revoke access to keys
- Key rotation and versioning
- Access logs and audit trails

## Getting Started
1. Clone the repository
2. Install dependencies with `npm install`
3. Run tests with `clarinet test`

## Contract Functions
- `create-key`: Create a new encrypted key entry
- `grant-access`: Grant access to a key for a principal
- `revoke-access`: Revoke access from a principal
- `rotate-key`: Create new version of existing key
- `get-key`: Retrieve key if authorized
