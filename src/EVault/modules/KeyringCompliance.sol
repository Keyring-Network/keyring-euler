// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import {Compliance} from "./Compliance.sol";

interface IKeyringCredentials {
    function policyManager() external view returns (address);
    function checkCredential(address, uint32) external view returns (bool);
}

contract KeyringCompliance is Compliance {
    IKeyringCredentials public immutable keyring;
    uint32 internal immutable policyId;

    constructor(Integrations memory integrations, address _keyring, uint32 _policyId) Compliance(integrations) {
        keyring = IKeyringCredentials(_keyring);
        policyId = _policyId;
    }

    function isAuthorized(address user) public view override (Compliance) reentrantOK returns (bool) {
        return keyring.checkCredential(user, policyId);
    }
}
