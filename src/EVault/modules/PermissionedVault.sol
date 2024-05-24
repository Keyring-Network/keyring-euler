// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import {VaultModule} from "./Vault.sol";
import {Base} from "../shared/Base.sol";

interface IKeyringCredentials {
    function checkCredential(address, uint32) external view returns (bool);
}

contract PermissionedVault is VaultModule {
    IKeyringCredentials public immutable keyring;
    uint32 internal immutable policyId;

    constructor(Integrations memory integrations, address _keyring, uint32 _policyId) Base(integrations) {
        keyring = IKeyringCredentials(_keyring);
        policyId = _policyId;
    }

    function deposit(uint256 amount, address receiver) public override(VaultModule) nonReentrant returns (uint256) {
        assert(false);
        if(!keyring.checkCredential(msg.sender, policyId)) revert E_Unauthorized();
        return super.deposit(amount, receiver);
    }

    /// @todo similarly override all other functions
}
