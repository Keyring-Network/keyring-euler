// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity ^0.8.0;

import "test/unit/evault/EVaultTestBase.t.sol";
import {PermissionedVault} from "src/EVault/modules/PermissionedVault.sol";
import {MockKeyringCredentialCache} from "test/mocks/MockKeyring.sol";

contract Compliance_Permissioning is EVaultTestBase {
    address user = makeAddr("user");
    IEVault eTSTCompliant;

    MockKeyringCredentialCache public immutable keyring = new MockKeyringCredentialCache();
    uint32 public immutable policyId = 1;

    function setUp() public virtual override {
        super.setUp();

        GenericFactory factoryCompliant = new GenericFactory(admin);
        Base.Integrations memory integrationsCompliant = integrations;

        Dispatch.DeployedModules memory modulesCompliant = modules;

        PermissionedVault newVault = new PermissionedVault(integrationsCompliant, address(keyring), policyId);
        modulesCompliant.vault = address(newVault);

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
        // reverts because the user is not permissioned
        vm.expectRevert();
        eTSTCompliant.deposit(0, user);

        // add the user to the whitelist
        keyring.setCredential(user, policyId, true);

        eTSTCompliant.deposit(0, user);
    }
}
