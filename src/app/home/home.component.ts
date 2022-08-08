import { Component, OnInit, AfterViewInit, ViewChild, ElementRef, ViewChildren, QueryList, NgZone, ChangeDetectionStrategy, ChangeDetectorRef, Input} from "@angular/core";
import { FormGroup, FormBuilder, FormControl, Validators } from '@angular/forms';
import {  Router, ActivatedRoute, ParamMap } from '@angular/router';
// import { DeviceDetectorService } from 'ngx-device-detector';
// import {
//   Alchemy,
//   Network,
//   initializeAlchemy,
//   getNftsForOwner,
//   getNftMetadata,
//   BaseNft,
//   NftTokenType,
// } from "@alch/alchemy-sdk";

// const Moralis = require('moralis');
// const axios = require('axios');
// import moment from 'moment';
import { environment } from '../../environments/environment';
import { SERVICE } from '../service/web3.service';
declare var ethereum: any;
declare var window:any;
declare var $: any;

// const settings = {
//   apiKey:  environment.alchemykey, // Replace with your Alchemy API Key.
//   network: Network.ETH_GOERLI, // Replace with your network.
// };
// const alchemy:any = initializeAlchemy(settings);
// const web3 = AlchemyWeb3.createAlchemyWeb3(
//   'https://eth-goerli.g.alchemy.com/v2/' + environment.alchemykey,
// );

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
})
export class HomeComponent implements OnInit {

  _createTell: FormGroup;
  _bid: FormGroup;
  _service:any;
  _user:any;
  _connected:any;
  _ismobile:any
  _ENS: any;
  _NFT: any;

  constructor(private formBuilder: FormBuilder,private service_: SERVICE,private zone: NgZone, private cd: ChangeDetectorRef,private route: ActivatedRoute,private router: Router) {

    this._service = service_;

    this.createForm();

  }

  ngOnInit() {

    this._user = localStorage.getItem('user');

    if (window.ethereum && !this._user) {
        // this.pop('success', 'connect your wallet')
        ethereum
          .enable()
          .then((accounts:any) => {
            // Metamask is ready to go!
            if(accounts){

              this._user = accounts.toString();
              localStorage.setItem('user',this._user);
              this._connected = true;
              this.getuserens();

            }
          })
          .catch((reason:any) => {
            // Handle error. Likely the user rejected the login.
            console.log(reason)

          });

      }else if(window.ethereum && this._user) {
        // The user doesn't have Metamask installed.
        ethereum.enable();
        this._connected = true;
        this.getuserens();

        // console.log(this._user);
      }else{

        this.pop('error','meta mask not accessible');
      }

  }

  async getConnected(){

    if (window.ethereum) {

        ethereum
          .enable()
          .then((accounts:any) => {
            // Metamask is ready to go!
            if(accounts){

              this._user = accounts.toString();
              localStorage.setItem('user',this._user);
              this._connected = true;
              this.getuserens();

            }
          })
          .catch((reason:any) => {
            // Handle error. Likely the user rejected the login.
            console.log(reason)

          });
      } else {
        // The user doesn't have Metamask installed.
        this.pop('error','meta mask not accessible');

      }

    }

  async getuserens(){

    // const ensContractAddress = "0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85";
    // this._ENS = await getNftsForOwner(alchemy, this._user, {
    //   contractAddresses: [ensContractAddress],
    // });
    // console.log(this._ENS);
    // this.getusernft();
  }

async getusernft(){

  // this._NFT = await getNftsForOwner(alchemy, this._user);
  // console.log(this._NFT);

}

async createnfttell(nftid_:any, nftcontract_:any){

    if (!this._createTell.controls.reserveprice.value){

      this.pop('error', 'what is the reserve price?');

    }else{

      this._service.createnfttell(this._user, nftcontract_, nftid_, this._createTell.controls.reserveprice.value)
      .then((res:any)=>{

      })

    }
  }

  async createenstell(enstokenid_:any){

    if (!this._createTell.controls.reserveprice.value){

      this.pop('error', 'what is the reserve price?');

    }else{

      this._service.createenstell(this._user, enstokenid_, this._createTell.controls.reserveprice.value)
      .then((res:any)=>{

      })

    }

  }

  async bid(vault_:any, bidamount_:any){

    if (!this._bid.controls.amount.value){

      this.pop('error', 'what is the bid amount');

    }else{

      this._service.createenstell(this._user, vault_, this._bid.controls.amount.value)
      .then((res:any)=>{

      })

    }
  }

  async bidaccept(vault_:any){

    this._service.bidaccept(this._user, vault_)
    .then((res:any)=>{

    })


  }

  async canceltell(vault_:any){

    this._service.canceltell(this._user, vault_)
    .then((res:any)=>{

    })
  }
  logout(){

    // Moralis.User.logOut();
    // this.pop('success','logging you out')
    // this._connected = false
    // this._user = null;
    // localStorage.clear();

  }
  private pop(type: any, message: any) {
    let title;
    if (type == 'error') {
      title = 'Error!';
    } else {
      title = 'Success!';
    }
  //
  //   Swal.fire({
  //     title: title,
  //     text: message,
  //     icon: type,
  //     confirmButtonText: 'Close',
  //   });
  }

  createForm(){

  this._createTell = this.formBuilder.group({

    reserveprice: [''],

  });

  this._bid = this.formBuilder.group({

    amount: [''],

  });
}




}
