pragma solidity ^0.5.0;

contract BigOrSmall{

    address payable internal owner;
    uint public ownerRemain;
    address payable internal playeraddr;

    struct Player{
        uint num;
        uint amount;
    }

    mapping(address => Player) public playerInfo;

    constructor() public payable{
        owner = msg.sender;
        ownerRemain = msg.value;
    }

    function playerBet(uint _num) public payable{
        require(_num >= 5);
        playerInfo[msg.sender].num = _num;
        require(msg.value>=1000000000000000000);
        playerInfo[msg.sender].amount = msg.value;
        playeraddr = msg.sender;

        owner.transfer(playerInfo[msg.sender].amount);
    }

    function draw(uint _winNum) public payable{
        require(msg.sender == owner);
        if(playerInfo[playeraddr].num < _winNum){
            uint prize = 2+(playerInfo[playeraddr].num-5)/5;
            playeraddr.transfer(playerInfo[playeraddr].amount*99/100*prize);
        }
        resetPlayer();
    }

    function resetPlayer() internal{
        playerInfo[playeraddr].num = 0;
        playerInfo[playeraddr].amount = 0;
    }

    function balanceOf(address player) public view returns (uint){
        return playerInfo[player].amount;
    }
}
