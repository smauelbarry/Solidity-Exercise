pragma solidity ^0.5.0;

contract lotto{

    address internal owner;
    address[] public winner;
    uint[] public lottoNum;
    address[] internal playeraddr;

    struct Player{
        uint[] lottonum;
        uint bet;
        uint remain;
    }

    mapping(address => Player) internal playerInfo;

    constructor() public{
        owner = msg.sender;
    }

    function register() public payable{
        require(!checkPlayerExisted(msg.sender));
        playerInfo[msg.sender].remain = msg.value;
        playeraddr.push(msg.sender);
    }

    function betIn(uint bet, uint[] memory num) public{
        require(playerInfo[msg.sender].remain > bet);
        for(uint i=0; i<5; i++){
            playerInfo[msg.sender].lottonum.push(num[i]);
        }
        playerInfo[msg.sender].remain -= bet;

        uint j=0;
        for(uint k=0; k<playeraddr.length; k++){
            if(playerInfo[playeraddr[k]].lottonum.length == 5)
                j+=1;
        }
        if(j == 2)
            draw();
    }

    function getPlayerInfo(address playernow) public view returns(uint[] memory lottonum, uint bet, uint remain){
        return (playerInfo[playernow].lottonum, playerInfo[playernow].bet, playerInfo[playernow].remain);
    }

    function checkPlayerExisted(address playernow) internal view returns(bool){
        for(uint i=0; i < playeraddr.length; i++){
            if(playeraddr[i] == playernow)
                return true;
        }
        return false;
    }

    function draw() internal{
        for(uint i=0; i<playeraddr.length; i++){
            for(uint j=0; j<5; j++){
                if(playerInfo[playeraddr[i]].lottonum[j] != lottoNum[j])
                    break;
                else if(j == 4){
                    winner.push(playeraddr[i]);
                }
            }
        }
    }
    
    function setLottoNum(uint[] memory lottonum) public{
        require(msg.sender == owner);
        lottoNum = lottonum;
    }

}
