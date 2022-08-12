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
const ABITELL = require('../contracts/abi/tell.json');

const WALLETS = environment.WALLETS;
const BANK = environment.BANK;
const NFT = environment.NFT;
const TELL = environment.TELL;
const WRAP = environment.WRAP;
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

public SETBACKUPACCESS(user_:any, backupaddress_:any, wallet_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.SETWEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "addbackupaccess",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'backup_'
          }]
        }, [backupaddress_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: wallet_,
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

public SETTURNONBACKUPACCESS(user_:any,  wallet_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.SETWEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "turnonbackupaccess",
          type: "function",
          inputs: []
        }, [user_, wallet_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: wallet_,
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

public SETTURNOFFBACKUPACCESS(user_:any,  wallet_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.SETWEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "turnoffbackupaccess",
          type: "function",
          inputs: []
        }, [user_, wallet_])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: wallet_,
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

  public SETHOLDNFT(user_:any,  nftcontract_:any, tokenid_:any, quantity_:any, wallet_:any): Promise<any> {
      return new Promise(async (resolve, reject) => {
        try {

          await this.SETWEB3();
          const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
            name: "holdnft",
            type: "function",
            inputs: [{
              type: 'address',
              name: 'nftcontract_'
            },{
              type: 'uint256',
              name: 'tokenid_'
            },{
              type: 'uint256',
              name: 'quantity_'
            }]
          }, [user_, nftcontract_, tokenid_, quantity_])
          const txt = await this.web3.eth.sendTransaction({
            from:user_,
            to: wallet_,
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

  public SETTRANSFERNFT(user_:any,  nftcontract_:any, tokenid_:any, quantity_:any, wallet_:any): Promise<any> {
      return new Promise(async (resolve, reject) => {
        try {

          await this.SETWEB3();
          const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
            name: "transfernft",
            type: "function",
            inputs: [{
              type: 'address',
              name: 'nftcontract_'
            },{
              type: 'uint256',
              name: 'tokenid_'
            },{
              type: 'uint256',
              name: 'quantity_'
            }]
          }, [user_, nftcontract_, tokenid_, quantity_])
          const txt = await this.web3.eth.sendTransaction({
            from:user_,
            to: wallet_,
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

  public SETWITHDRAWETH(user_:any, wallet_:any): Promise<any> {
      return new Promise(async (resolve, reject) => {
        try {

          await this.SETWEB3();
          const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
            name: "withdraweth",
            type: "function",
            inputs: []
          }, [user_, wallet_])
          const txt = await this.web3.eth.sendTransaction({
            from:user_,
            to: wallet_,
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
  public SETTRANSERTOKEN(user_:any, wallet_:any, token_:any, value_:any): Promise<any> {
      return new Promise(async (resolve, reject) => {
        try {

          await this.SETWEB3();
          const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
            name: "transfertoken",
            type: "function",
            inputs: [{
              type: 'address',
              name: 'token_'
            },{
              type: 'uint256',
              name: 'value_'
            }]
          }, [user_, token_, value_])
          const txt = await this.web3.eth.sendTransaction({
            from:user_,
            to: wallet_,
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

  public SETLOCKWALLET(user_:any, untiltime_:any, wallet_:any): Promise<any> {
      return new Promise(async (resolve, reject) => {
        try {

          await this.SETWEB3();
          const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
            name: "transfertoken",
            type: "function",
            inputs: [{
              type: 'uint256',
              name: 'untiltime_'
            }]
          }, [user_, untiltime_])
          const txt = await this.web3.eth.sendTransaction({
            from:user_,
            to: wallet_,
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

public APPROVE721(user_:any, nftcontract_:any, nftid_:any): Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {

        await this.SETWEB3();
        const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
          name: "setApprovalForAll",
          type: "function",
          inputs: [{
            type: 'address',
            name: 'operator'
          },{
            type:'bool',
            name:'approved'

          }]
        }, [user_, true])
        const txt = await this.web3.eth.sendTransaction({
          from:user_,
          to: TELL,
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

  public APPROVE1155(user_:any, nftcontract_:any, nftid_:any): Promise<any> {
      return new Promise(async (resolve, reject) => {
        try {

          await this.SETWEB3();
          const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
            name: "setApprovalForAll",
            type: "function",
            inputs: [{
              type: 'address',
              name: 'operator'
            },{
              type:'bool',
              name:'approved'

            }]
          }, [user_, true])
          const txt = await this.web3.eth.sendTransaction({
            from:user_,
            to: TELL,
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

    public SETTELL(user_:any, nftcontract_:any, nftid_:any, nftcategory_:any, prints_:any, reserveprice_:any, buyprice_:any): Promise<any> {
        return new Promise(async (resolve, reject) => {
          try {
            // console.log(uri_);

            await this.SETWEB3();
            const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
              name: "setnftmint",
              type: "function",
              inputs: [{
                type: 'address',
                name: 'nftcontract_'
              },{
                type: 'uint256',
                name: 'nftid_'
              },{
                type: 'uint256',
                name: 'nftcategory_'
              },{
                type: 'uint256',
                name: 'prints_'
              },{
                type: 'uint256',
                name: 'reserveprice_'
              },{
                type: 'uint256',
                name: 'buyprice_'
              }]

            }, [nftcontract_, nftid_, nftcategory_, prints_,reserveprice_,buyprice_])
            const txt = await this.web3.eth.sendTransaction({
              from:user_,
              to: TELL,
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

    public SETCANCELTELL(user_:any, tellid_:any): Promise<any> {
        return new Promise(async (resolve, reject) => {
          try {
            // console.log(uri_);

            await this.SETWEB3();
            const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
              name: "setnftmint",
              type: "function",
              inputs: [{
                type: 'address',
                name: 'tellid_'
              }]

            }, [tellid_])
            const txt = await this.web3.eth.sendTransaction({
              from:user_,
              to: TELL,
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

    public SETBID(user_:any, tellid_:any, bidamount_:any): Promise<any> {
        return new Promise(async (resolve, reject) => {
          try {
            // console.log(uri_);

            await this.SETWEB3();
            const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
              name: "bid",
              type: "function",
              inputs: [{
                type: 'uint256',
                name: 'tellid_'
              },{
                type: 'uint256',
                name: 'bidamount_'
              }]

            }, [tellid_, bidamount_])
            const txt = await this.web3.eth.sendTransaction({
              from:user_,
              to: TELL,
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

    public SETACCEPTBID(user_:any, tellid_:any): Promise<any> {
        return new Promise(async (resolve, reject) => {
          try {
            // console.log(uri_);

            await this.SETWEB3();
            const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
              name: "bid",
              type: "function",
              inputs: [{
                type: 'uint256',
                name: 'tellid_'
              }]

            }, [tellid_])
            const txt = await this.web3.eth.sendTransaction({
              from:user_,
              to: TELL,
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

    public SETWRAPNFT(user_:any, nftcontract_:any, nftid_:any, ipfs_:any, data_:any): Promise<any> {
        return new Promise(async (resolve, reject) => {
          try {
            // console.log(uri_);

            await this.SETWEB3();
            const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
              name: "wrap",
              type: "function",
              inputs: [{
                type: 'address',
                name: 'nftcontract_'
              },{
                type: 'uint256',
                name: 'nftid_'
              },{
                type: 'string',
                name: 'ipfs_'
              },{
                type: 'bytes',
                name: 'data_'
              }]

            }, [nftcontract_, nftid_,ipfs_,data_])
            const txt = await this.web3.eth.sendTransaction({
              from:user_,
              to: WRAP,
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

    public SETREDEEMCOUPON(user_:any, wnft_:any): Promise<any> {
        return new Promise(async (resolve, reject) => {
          try {
            // console.log(uri_);

            await this.SETWEB3();
            const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
              name: "redeemCoupon",
              type: "function",
              inputs: [{
                type: 'uint256',
                name: 'wnft_'
              }]

            }, [wnft_])
            const txt = await this.web3.eth.sendTransaction({
              from:user_,
              to: WRAP,
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

    public SETJOINTRIBE(user_:any, tribeid_:any): Promise<any> {
        return new Promise(async (resolve, reject) => {
          try {
            // console.log(uri_);

            await this.SETWEB3();
            const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
              name: "createtribe",
              type: "function",
              inputs: [{
                type: 'uint256',
                name: 'tribeid_'
              }]

            }, [tribeid_])
            const txt = await this.web3.eth.sendTransaction({
              from:user_,
              to: TELL,
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

    public SETLEAVETRIBE(user_:any, tribeid_:any): Promise<any> {
        return new Promise(async (resolve, reject) => {
          try {
            // console.log(uri_);

            await this.SETWEB3();
            const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
              name: "createtribe",
              type: "function",
              inputs: [{
                type: 'uint256',
                name: 'tribeid_'
              }]

            }, [tribeid_])
            const txt = await this.web3.eth.sendTransaction({
              from:user_,
              to: TELL,
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

      public SETTAKETOKEN(user_:any, tokenaddress_:any, tribeid_:any): Promise<any> {
          return new Promise(async (resolve, reject) => {
            try {
              // console.log(uri_);

              await this.SETWEB3();
              const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
                name: "taketoken",
                type: "function",
                inputs: [{
                  type: 'address',
                  name: 'tokenaddress_'
                },{
                  type: 'uint256',
                  name: 'tribeid_'
                }]

              }, [tokenaddress_,tribeid_])
              const txt = await this.web3.eth.sendTransaction({
                from:user_,
                to: TELL,
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

      public SETTAKENFT(user_:any, tokenaddress_:any, nftid_:any, tribeid_:any): Promise<any> {
          return new Promise(async (resolve, reject) => {
            try {
              // console.log(uri_);

              await this.SETWEB3();
              const encodedFunction = this.web3.eth.abi.encodeFunctionCall({
                name: "taketoken",
                type: "function",
                inputs: [{
                  type: 'address',
                  name: 'tokenaddress_'
                },{
                  type: 'uint256',
                  name: 'nftid_'
                },{
                  type: 'uint256',
                  name: 'tribeid_'
                }]

              }, [tokenaddress_,nftid_,tribeid_])
              const txt = await this.web3.eth.sendTransaction({
                from:user_,
                to: TELL,
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
