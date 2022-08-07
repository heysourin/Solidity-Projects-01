// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

contract ComputerCompany{

//we are creating object of desktop contract
//and creating array to keep multiple records
    Desktop[] public desktop;

    function creater() public{
        // Desktop desktop = new Desktop(); //we can create like this also but here we can never store 
                                            // datas of multiple objects
                                            
        desktop.push(new Desktop());
    }
}


contract Desktop{

}
