// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity ^0.8.0;

import "test/unit/evault/EVaultTestBase.t.sol";
import {KeyringCompliance} from "src/EVault/modules/KeyringCompliance.sol";
import {MockKeyringCredentialCache} from "test/mocks/MockKeyring.sol";

contract Compliance_Permissioning is EVaultTestBase {
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    IEVault eTSTCompliant;

    MockKeyringCredentialCache public immutable keyring = new MockKeyringCredentialCache();
    uint32 public immutable policyId = 1;

    function setUp() public virtual override {
        super.setUp();

        GenericFactory factoryCompliant = new GenericFactory(admin);
        Base.Integrations memory integrationsCompliant = integrations;

        Dispatch.DeployedModules memory modulesCompliant = modules;

        modulesCompliant.compliance = address(new KeyringCompliance(integrationsCompliant, address(keyring), policyId));

        address evaultImpl = address(new EVault(integrationsCompliant, modulesCompliant));

        vm.prank(admin);
        factoryCompliant.setImplementation(evaultImpl);

        eTSTCompliant = IEVault(
            factoryCompliant.createProxy(
                address(0), true, abi.encodePacked(address(assetTST), address(oracle), unitOfAccount)
            )
        );
    }

    function test_CanAccess() public {
        // generic dummy implementation always passes
        assertTrue(eTST.isAuthorized(alice));

        // keyring-permissioned vault
        assertFalse(eTSTCompliant.isAuthorized(alice));
        keyring.setCredential(alice, policyId, true);
        assertTrue(eTSTCompliant.isAuthorized(alice));
    }
}
