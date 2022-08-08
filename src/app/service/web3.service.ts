import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { environment } from '../../environments/environment';
// const Moralis = require('moralis');
// import {
//   Network,
//   initializeAlchemy,
//   getNftsForOwner,
//   getNftMetadata,
//   BaseNft,
//   NftTokenType,
// } from "@alch/alchemy-sdk";
const ABITELL = require('../contracts/abi/721.json');
const ABIVAULT721 = require('../contracts/abi/1155.json');
// const web3 = createAlchemyWeb3(
//   "https://eth-testnet.alchemyapi.io/v2/"+environment.alchemykey,
// );
const TELL = environment.TELL;
const HOLDER721 = environment.HOLDER721;

// import moment from 'moment';
declare var ethereum: any;
declare var window:any;

@Injectable({
  providedIn: 'root',
})
export class SERVICE {
  isMobile: any;
  web3: any;
  user: any;

  constructor() {

    this.GET_WEB3();
  }

  async GET_WEB3(): Promise<any> {

    let accounts:any;

    if (window.ethereum) {
        ethereum
          .enable()
          .then((accounts:any) => {
            // Metamask is ready to go!
            // console.log(accounts)
          })
          .catch((reason:any) => {
            // Handle error. Likely the user rejected the login.
            console.log(reason)

          });
      } else {
        // The user doesn't have Metamask installed.
      }
    let res = { success: true, accounts:accounts };
    return res;

  }

  public getuser1155(_user:any): Promise<any>{
    return new Promise(async (resolve, reject)=>{
      try {

      } catch (error) {
        //console.log(JSON.stringify(error.error));
        let result = {};
        resolve(result);
        //console.log(JSON.stringify(error.error));
      }


    })
  }

  public gettells(type_:any): Promise<string> {
    return new Promise(async (resolve, reject) => {
      try {
        // console.log("in the back getting profile 1 " + NFT);
        await this.GET_WEB3();
        const contract = new this.web3.eth.Contract(ABITELL, TELL);
        let result = await contract.methods.gettells(type_).call();
        resolve(result);

      } catch (error) {
        console.log(error)
      }
    })
  }
  public gettell(vault_:any): Promise<string> {
    return new Promise(async (resolve, reject) => {
      try {
        // console.log("in the back getting profile 1 " + NFT);
        await this.GET_WEB3();
        const contract = new this.web3.eth.Contract(ABITELL, TELL);
        let result = await contract.methods.gettell(vault_).call();
        resolve(result);

      } catch (error) {
        console.log(error)
      }
    })
  }
  public getbids(vault_:any): Promise<string> {
    return new Promise(async (resolve, reject) => {
      try {
        // console.log("in the back getting profile 1 " + NFT);
        await this.GET_WEB3();
        const contract = new this.web3.eth.Contract(ABITELL, TELL);
        let result = await contract.methods.getbids(vault_).call();
        resolve(result);

      } catch (error) {
        console.log(error)
      }
    })
  }
  public get1stbidder(vault_:any): Promise<string> {
    return new Promise(async (resolve, reject) => {
      try {
        // console.log("in the back getting profile 1 " + NFT);
        await this.GET_WEB3();
        const contract = new this.web3.eth.Contract(ABITELL, TELL);
        let result = await contract.methods.get1stbidder(vault_).call();
        resolve(result);

      } catch (error) {
        console.log(error)
      }
    })
  }

  public createmint(user_: any, title_:any, desc_:any, price_:any, prints_:any, payto_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.GET_WEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "createnfttell",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'nftcontract_'
          },{
            type: 'uint256',
            name: 'nftid_'
          },{
            type: 'uint256',
            name: 'reserveprice_'
          }]
        }, [title_, desc_, price_,prints_,payto_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: TELL,
          gas: 1000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{

              resolve({ success: true, msg: hash });
          })
          .on('receipt',(receipt:any)=>{
             //console.log(receipt:any)
             this.pop('success', 'nft tell created');

          })
          .on('confirmation',(confirmationNumber:any, receipt:any)=>
          {
          //console.log(confirmationNumber:any, receipt:any)
          }).on('error', console.error);

      } catch (error) {
        resolve({success:false,msg:error});
      }
    })
  }
  public createnfttell(user_: any, nftcontract_:any, nftid_:any, reserveprice_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.GET_WEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "createnfttell",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'nftcontract_'
          },{
            type: 'uint256',
            name: 'nftid_'
          },{
            type: 'uint256',
            name: 'reserveprice_'
          }]
        }, [nftcontract_, nftid_, reserveprice_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: TELL,
          gas: 1000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{

              resolve({ success: true, msg: hash });
          })
          .on('receipt',(receipt:any)=>{
             //console.log(receipt:any)
             this.pop('success', 'nft tell created');

          })
          .on('confirmation',(confirmationNumber:any, receipt:any)=>
          {
          //console.log(confirmationNumber:any, receipt:any)
          }).on('error', console.error);

      } catch (error) {
        resolve({success:false,msg:error});
      }
    })
  }

  public createenstell(user_: any, enstokenid_:any, reserveprice_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.GET_WEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "createenstell",
          type: "function",
          inputs: [{
            type: 'uint256',
            name: 'enstokenid_'
          },{
            type: 'uint256',
            name: 'reserveprice_'
          }]
        }, [enstokenid_, reserveprice_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: TELL,
          gas: 1000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{

              resolve({ success: true, msg: hash });
          })
          .on('receipt',(receipt:any)=>{
             //console.log(receipt:any)
             this.pop('success', 'ens tell created');

          })
          .on('confirmation',(confirmationNumber:any, receipt:any)=>
          {
          //console.log(confirmationNumber:any, receipt:any)
          }).on('error', console.error);

      } catch (error) {
        resolve({success:false,msg:error});
      }
    })
  }

  public bid(user_: any, vault_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.GET_WEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "bid",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'vault_'
          }]
        }, [vault_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: TELL,
          gas: 1000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{

              resolve({ success: true, msg: hash });
          })
          .on('receipt',(receipt:any)=>{
             //console.log(receipt:any)
             this.pop('success', 'bid placed');

          })
          .on('confirmation',(confirmationNumber:any, receipt:any)=>
          {
          //console.log(confirmationNumber:any, receipt:any)
          }).on('error', console.error);

      } catch (error) {
        resolve({success:false,msg:error});
      }
    })
  }

  public bidaccept(user_: any, vault_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.GET_WEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "acceptbid",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'vault_'
          }]
        }, [vault_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: TELL,
          gas: 1000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{

              resolve({ success: true, msg: hash });
          })
          .on('receipt',(receipt:any)=>{
             //console.log(receipt:any)
             this.pop('success', 'bid accepted');

          })
          .on('confirmation',(confirmationNumber:any, receipt:any)=>
          {
          //console.log(confirmationNumber:any, receipt:any)
          }).on('error', console.error);

      } catch (error) {
        resolve({success:false,msg:error});
      }
    })
  }

  public canceltell(user_: any, vault_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.GET_WEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "canceltell",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'vault_'
          }]
        }, [vault_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: TELL,
          gas: 1000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{

              resolve({ success: true, msg: hash });
          })
          .on('receipt',(receipt:any)=>{
             //console.log(receipt:any)
             this.pop('success', 'bid canceled');

          })
          .on('confirmation',(confirmationNumber:any, receipt:any)=>
          {
          //console.log(confirmationNumber:any, receipt:any)
          }).on('error', console.error);

      } catch (error) {
        resolve({success:false,msg:error});
      }
    })
  }

  private pop(type: any, message: any) {
    let title;
    if (type == 'error') {
      title = 'Error!';
    } else {
      title = 'Success!';
    }

    // Swal.fire({
    //   title: title,
    //   text: message,
    //   icon: type,
    //   confirmButtonText: 'Close',
    // });
  }
}
