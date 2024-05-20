// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import {Compliance} from "./Compliance.sol";

interface IKeyringCredentials {
    function policyManager() external view returns (address);
    function checkCredential(address, bytes32) external view returns (bool);
}

contract KeyringCompliance is Compliance {
    IKeyringCredentials public immutable keyring;
    bytes32 internal immutable policyId;

    constructor(Integrations memory integrations, address _keyring, bytes32 _policyId) Compliance(integrations) {
        keyring = IKeyringCredentials(_keyring);
        policyId = _policyId;
    }

    function isAllowed(address user) public view override (Compliance) reentrantOK returns (bool) {
        return keyring.checkCredential(user, policyId);
    }
}
