// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IDAO} from "@aragon/osx/core/dao/IDAO.sol";
import {Ikernel} from "@aragon/os/contracts/kernel/IKernel.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {PermissionLib} from "@aragon/osx/core/permission/PermissionLib.sol";
import {PluginSetup, IPluginSetup} from "@aragon/osx/framework/plugin/setup/PluginSetup.sol";
// import {Address} from "./Address.sol";

contract AddressSetup is PluginSetup {
    using SafeMath for uint256;
    using SafeERC20 for IERC20; 

    IKernel public kernel;
    IAppManager public appManager;
    address public vault;

    event PluginDeployed(address pluginAddress);

    constructor(address _kernel, address _appManager, address _vault) {
        require(_kernel != address(0), "Invalid kernel address");
        require(_appManager != address(0), "Invalid appManager address");
        require(_vault != address(0), "Invalid vault address");

        kernel = IKernel(_kernel);
        appManager = IAppManager(_appManager);
        vault = _vault;
    }

    function deployPlugin() external {
        bytes memory initializeData = abi.encodeWithSelector(EthereumAddressStorage.initialize.selector);

        address pluginAddress = appManager.createPermissionlessApp(address(this), kernel.APP_BASES_NAMESPACE(), initializeData);

        emit PluginDeployed(pluginAddress);
    }
}
