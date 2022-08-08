import { Component, OnInit, AfterViewInit, ViewChild, ElementRef, ViewChildren, QueryList, NgZone, ChangeDetectionStrategy, ChangeDetectorRef, Input} from "@angular/core";
import { FormGroup, FormBuilder, FormControl, Validators, FormArray } from '@angular/forms';
import {  Router, ActivatedRoute, ParamMap } from '@angular/router';
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
declare var NiceSelect:any;

// const settings = {
//   apiKey:  environment.alchemykey, // Replace with your Alchemy API Key.
//   network: Network.ETH_GOERLI, // Replace with your network.
// };
// const alchemy:any = initializeAlchemy(settings);
// const web3 = AlchemyWeb3.createAlchemyWeb3(
//   'https://eth-goerli.g.alchemy.com/v2/' + environment.alchemykey,
// );

@Component({
  selector: 'app-mint',
  templateUrl: './mint.component.html',
  styleUrls: ['./mint.component.scss'],
})
export class MintComponent implements OnInit {

  _collection: FormGroup;
  _mint: FormGroup;
  _nfttype:any;
  _collectiontype:any;
  _termsagreed:any;
  _service:any;
  _user:any;
  _connected:any;
  _ismobile:any
  _ENS: any;
  _NFT: any;
  _fileUploading:any;
  _toFile:any;
  _image:any;
  _collectionimage:any;
  _collectionid:any;

  _showcreatecollection:any;
  _showcreatenft:any;

  _nftoptions: any = [
    { id: 1, name: 'Single Mint' },
    { id: 2, name: 'Multiple Prints' },
    { id: 3, name: 'Multiple Prints For Coupons' }
  ];
  _collectionoptions: any = [
    { id: 1, name: 'Art' },
    { id: 2, name: 'Music' },
    { id: 3, name: 'Video' },
    { id: 4, name: 'Photography' },
    { id: 5, name: 'NSFW Art' },
    { id: 6, name: 'NSFW Photo' }

  ];
  constructor(private formBuilder: FormBuilder,private service_: SERVICE,private zone: NgZone, private cd: ChangeDetectorRef,private route: ActivatedRoute,private router: Router) {

    this._service = service_;
    this._termsagreed = false;
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
              this.getusercollections();

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
        this.getusercollections();

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

  async getusercollections(){

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

async upload(event:any, type:any){

  // console.log(type);
  this._fileUploading = true;
  this._toFile = event.target.files[0];

}

async createcollection(){

  let pass = true;

  if(!this._collectionimage){

    this.pop('error', 'whats the collection image?');
    pass = false;

  }
  if(!this._collection.controls.title.value){

    this.pop('error', 'whats the collection title?');
    pass = false;

  }
  if(!this._collection.controls.desc.value){

    this.pop('error', 'whats the collection description?');
    pass = false;

  }
  if(pass){

    this._service.createcollection(this._user,this._collectionimage,this._collection.controls.title.value,this._collection.controls.desc.value, this._collectiontype)
    .then((res:any)=>{

    })
  }
}

async createmint(){

    let payto_:any;
    let pass = true;

    if(!this._image){

      this.pop('error', 'whats the nft image?');
      pass = false;

    }
    if(!this._nfttype && pass){

      this.pop('error', 'what is the mint type?');
      pass = false;

    }
    if (!this._mint.controls.title.value && pass){

      this.pop('error', 'what is the title?');
      pass = false;

    }
    if(!this._mint.controls.desc.value && pass){

      this.pop('error', 'what is the details?');
      pass = false;

    }
    if(!this._mint.controls.price.value && pass){

      this.pop('error', 'what is the reserve price?');
      pass = false;


    }
    if(!this._mint.controls.royalty.value && pass){

      this.pop('error', 'what is your royalty?');
      pass = false;

    }

    if(!this._mint.controls.prints.value && pass){

      this.pop('error', 'how many prints?');
      pass = false;

    }
    if(!this._mint.controls.payaddress.value && pass){

      this.pop('error', 'who do we pay to?');
      pass = false;

    }
    if(!this._termsagreed && pass){

      this.pop('error', 'must agree to terms');
      pass = false;
    }
    if(pass){

      console.log('going..')
      if(!payto_){
        payto_ = this._mint.controls.payaddress.value;
      }
      this._service.createmint(this._user, this._mint.controls.title.value, this._mint.controls.desc.value, this._mint.controls.price.value, this._mint.controls.prints.value, payto_, this._nfttype)
      .then((res:any)=>{

        if(res.success){
          this.pop('success', 'nft minted');
        }else{
          this.pop('error', res.message);

        }

      })
    }else{
      console.log(this._mint.controls.royalty.value);
    }
  }
  async onCheckboxChange(e:any, type_:any) {

     if (e.target.checked) {
        if(type_==1){
          this._nfttype = e.target.value;

        }else{
          this._collectiontype = e.target.value;
        }
       // console.log(this._nfttype);
     }
   }
   async onTermsChange(e:any) {

      if (e.target.checked) {
        this._termsagreed = true;
      }else{
        this._termsagreed = false;
      }
      console.log(this._termsagreed);
    }
  logout(){

    // Moralis.User.logOut();
    this.pop('success','logging you out')
    this._connected = false
    this._user = null;
    localStorage.clear();

  }
  private pop(type: any, message: any) {
    let title;
    if (type == 'error') {
      title = 'Error!';
    } else {
      title = 'Success!';
    }
    //
    // Swal.fire({
    //   title: title,
    //   text: message,
    //   icon: type,
    //   confirmButtonText: 'Close',
    // });
  }

  createForm(){

  this._mint = this.formBuilder.group({

    title: [''],
    desc: [''],
    price: [''],
    royalty: [''],
    prints: [''],
    payaddress: [''],
    terms: [''],

  });

  this._collection = this.formBuilder.group({

    title: [''],
    desc: ['']

  });

}




}
