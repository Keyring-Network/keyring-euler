# Euler Vault Kit with Keyring Integation
We showcase one of the possible ways in which Keyring can be added to the Euler Vault Kit in order to add permissioning to its vaults.

## The Compliance module
Following the modularised structure already in place, we added a new *Compliance module* where Keyring logic will sit. Vault users can replace this module with a dummy one to remove permissioning from their vaults if they wish.
The set *policyId* cannot be changed, this choice was made in order to preserve an unopinionated ownership or governance model.

## Changes
- We add the COMPLIANCE handler to the list of modules in `EVault/Dispatch.sol`
- Create two new modules inside the *modules* folder, one dummy `Compliance.sol` one for permissionless vaults and a `KeyringCompliance` module for permissioned ones
- Adding the module to the test setup files, `EVaultTestBase.sol` and `Setup.t.sol`

## ToDo
- [x] add module
- [x] code compile
- [] run Slither
- [ ] tests

