
// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.0;

import {SafeCastUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/math/SafeCastUpgradeable.sol";

import {ProposalUpgradeable} from "@aragon/osx/core/plugin/proposal/ProposalUpgradeable.sol";
import {IMembership} from "@aragon/osx/core/plugin/membership/IMembership.sol";
import {PluginCloneable} from "@aragon/osx/core/plugin/PluginCloneable.sol";
import {IDAO} from "@aragon/osx/core/dao/IDAO.sol";

contract Address  {
    mapping(bytes32 => address) public addresses;
    bytes32[] public addressKeys;

    event AddressAdded(bytes32 indexed key, address indexed value);
    event AddressRemoved(bytes32 indexed key);

    function addAddress(bytes32 key, address value) public {
        require(key != bytes32(0), "Invalid key");
        require(value != address(0), "Invalid value");
        require(addresses[key] == address(0), "Address already exists");

        addresses[key] = value;
        addressKeys.push(key);

        emit AddressAdded(key, value);
    }

    function removeAddress(bytes32 key) public {
        require(key != bytes32(0), "Invalid key");
        require(addresses[key] != address(0), "Address does not exist");

        addresses[key] = address(0);

        for (uint256 i = 0; i < addressKeys.length; i++) {
            if (addressKeys[i] == key) {
                addressKeys[i] = addressKeys[addressKeys.length - 1];
                addressKeys.pop();
                break;
            }
        }

        emit AddressRemoved(key);
    }

    function getAddress(bytes32 key) public view returns (address) {
        require(key != bytes32(0), "Invalid key");
        return addresses[key];
    }

    function getAddressKeys() public view returns (bytes32[] memory) {
        return addressKeys;
    }
}
