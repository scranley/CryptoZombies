// SPDX-License-Identifier: MIT
pragma solidity >=0.6.19 <0.8.6;
import "@openzeppelin/contracts/access/ownable.sol";
import "@openzeppelin/contracts/utils/math/safemath.sol";
contract ZombieFactory is Ownable {
  using SafeMath for uint256;
  event NewZombie(uint zombieId, string name, uint dna);
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;
  struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }
  Zombie[] public zombies;
  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;
  function _createZombie(string memory _name, uint _dna) internal {
    zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    zombieToOwner[zombies.length] = msg.sender;
    ownerZombieCount[msg.sender]++;
    emit NewZombie(zombies.length, _name, _dna);
  }
  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(bytes(_str)));
    return rand % dnaModulus;
  }
  function createRandomZombie(string memory _name) public {
    require(ownerZombieCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createZombie(_name, randDna);
  }
}

