import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { environment } from '../../environments/environment';
declare var Moralis:any;
declare var Web3:any;
declare var $: any;

const ABIBANK = require('../contracts/abi/bank.json');
const ABIWALLETS = require('../contracts/abi/wallets.json');
const ABINFT = require('../contracts/abi/nft.json');

const WALLETS = environment.WALLETS;
const BANK = environment.BANK;
const NFT = environment.NFT;
const CHAIN = environment.CHAIN;

// import moment from 'moment';

@Injectable({
  providedIn: 'root',
})
export class SERVICE {
  isMobile: any;
  web3: any;
  // user: any;

  constructor() {

  }
async SETWEB3(): Promise<any>{

  await Moralis.enableWeb3();
  this.web3 = new Web3(Moralis.provider);
  // console.log(this.web3);

}

public GETUSERWALLET(user_:any): Promise<string> {
    return new Promise(async (resolve, reject) => {
      try {

          const options = {
          chain: CHAIN,
          address: WALLETS,
          function_name: "GETUSERWALLET",
          abi: ABIWALLETS,
          params: { user_: user_ },
        };

        const result = await Moralis.Web3API.native.runContractFunction(options);
        // console.log(result);
        resolve(result);

      } catch (error) {

      }
    })
}

public SETUSERWALLET(user_:any, username_:any, email_:any, story_:any, avatarcontract_:any, avatarid_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {
        let name_ = 'main wallet';
        await this.SETWEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "CREATEUSERWALLET",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'user_'
          },{
            type: 'string',
            name: 'name_'
          }]
        }, [user_, name_.toString()])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: WALLETS,
          gas: 3000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{

            resolve({ success: true, msg: hash });

          }).on('receipt',(receipt:any)=>{

              const _uProfile = Moralis.Object.extend("profile");
              const _p = new _uProfile();
              _p.save({

                user: user_,
                email: email_,
                story:story_,
                avatarcontract_: avatarcontract_,
                avatarid_: avatarid_,
                name: username_

              }).then(()=>{

                console.log('saved it ' + user_);

              })
          }).on('confirmation',(confirmationNumber:any, receipt:any)=>{
          //console.log(confirmationNumber, receipt)
          }).on('error', console.error);

      } catch (error) {

      }
    })
}

public SETUSERNEWWALLET(user_:any, name_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.SETWEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "CREATEUSERWALLET",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'user_'
          },{
            type: 'string',
            name: 'name_'
          }]
        }, [user_, name_.toString()])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: WALLETS,
          gas: 3000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{


          }).on('receipt',(receipt:any)=>{

            resolve({ success: true, msg: receipt });

          }).on('confirmation',(confirmationNumber:any, receipt:any)=>{
          //console.log(confirmationNumber, receipt)
          }).on('error', console.error);

      } catch (error) {

      }
    })
}

public SETCOLLECTION(user_:any, image_:any, title_:any, desc_:any, category_:any, media_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {
        // console.log('yep its working' +  media_);

        await this.SETWEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "setcollection",
          type: "function",
          inputs: [{
            type: 'string',
            name: 'title_'
          },{
            type: 'string',
            name: 'details_'
          },{
            type: 'string',
            name: 'image_'
          },{
            type: 'string',
            name: 'media_'
          },{
            type: 'uint256',
            name: 'category_'
          }]
        }, [title_.toString(), desc_.toString(),image_.toString(),media_.toString(),category_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: NFT,
          gas: 3000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{


          }).on('receipt',(receipt:any)=>{

            resolve({ success: true, msg: receipt });

          }).on('confirmation',(confirmationNumber:any, receipt:any)=>{
          //console.log(confirmationNumber, receipt)
          }).on('error', console.error);

      } catch (error) {

      }
    })
}

public GETUSERCOLLECTIONS(user_:any): Promise<string> {
    return new Promise(async (resolve, reject) => {
      try {

          const options = {
          chain: CHAIN,
          address: NFT,
          function_name: "getcollections",
          abi: ABINFT,
          params: { user_: user_ },
        };

        const result = await Moralis.Web3API.native.runContractFunction(options);
        // console.log(result);
        resolve(result);

      } catch (error) {

      }
    })
}

public GETCOLLECTION(collection_:any): Promise<string> {
    return new Promise(async (resolve, reject) => {
      try {

          const options = {
          chain: CHAIN,
          address: NFT,
          function_name: "getcollection",
          abi: ABINFT,
          params: { collectionid_: collection_ },
        };

        const result = await Moralis.Web3API.native.runContractFunction(options);
        console.log(result);
        resolve(result);

      } catch (error) {

      }
    })
}

public SETMINT(user_:any, uri_:any, ipfs_:any, collectionid_:any, royalty_:any, prints_:any, payto_:any,redeems_:any,category_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {
        console.log(uri_);

        await this.SETWEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "setnftmint",
          type: "function",
          inputs: [{
            type: 'bytes',
            name: 'data_'
          },{
            type: 'string',
            name: 'ipfs_'
          },{
            type: 'uint256',
            name: 'collection_'
          },{
            type: 'uint256',
            name: 'royalty_'
          },{
            type: 'uint256',
            name: 'prints_'
          },{
            type: 'address',
            name: 'payto_'
          },{
            type: 'uint256',
            name: 'redeems_'
          },{
            type: 'uint256',
            name: 'category_'
          }]

        }, [this.web3.utils.asciiToHex(uri_),ipfs_.toString(), collectionid_,royalty_,prints_,payto_,redeems_,category_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: NFT,
          gas: 6000000,
          data:encodedFunction
        }).on('transactionHash',(hash:any)=>{


          }).on('receipt',(receipt:any)=>{

            resolve({ success: true, msg: receipt });

          }).on('confirmation',(confirmationNumber:any, receipt:any)=>{
          //console.log(confirmationNumber, receipt)
          }).on('error', console.error);

      } catch (error) {

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
