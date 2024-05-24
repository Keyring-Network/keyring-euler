# Euler Vault Kit with Keyring Integation
We showcase one of the possible ways in which Keyring can be added to the Euler Vault Kit in order to add permissioning to its vaults.

## The Permissioned Vault
Following the modularised structure already in place, we added a new *Permissioned Vault module* where Keyring logic will sit. It overrides the existing `Vault` to add Keyring permissioning to the ERC4626 standard functions (so far just to `deposit` but it can be extended to all the other state-changing methods too).
As it is an addition to the EVK, no elements of the existing codebase have been changed and no re-audit is required.

### Assumptions
The chosen policyId is immutable and cannot be changed, this choice was made in order to preserve an unopinionated ownership / governance model.

### Testing
We enriched the tests on modules with a new one under *test/unit/evault/modules/Compliance* folder where we etch the vault using the new Keyring compliant vault and mock the protocol to showcase permissioning.

#### Note: testing issues
The Vault module etching in the *permissioning.t.sol* test doesn't succeed correctly, the call to the `deposit` function is routed to the canonical vault and not to the `PermissionedVault` somehow.
Once that is solved, the `test_CanAccess` should pass.
