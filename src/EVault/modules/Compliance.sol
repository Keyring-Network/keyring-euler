// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import {Base} from "../shared/Base.sol";

abstract contract ComplianceModule is Base {
    function isAllowed(address /*user*/ ) public view virtual returns (bool);
}

contract Compliance is ComplianceModule {
    constructor(Integrations memory integrations) Base(integrations) {}

    /// @dev dummy function for permissionless vaults
    function isAllowed(address /*user*/ ) public view virtual override reentrantOK returns (bool) {
        return true;
    }
}
