import { Component, OnInit, AfterViewInit, ViewChild, ElementRef, ViewChildren, QueryList, NgZone, ChangeDetectionStrategy, ChangeDetectorRef, Input} from "@angular/core";
import { FormGroup, FormBuilder, FormControl, Validators, FormArray } from '@angular/forms';
import {  Router, ActivatedRoute, ParamMap } from '@angular/router';
import { environment } from '../../environments/environment';
import { SERVICE } from '../service/web3.service';
const address0 = environment.address0;
declare var Moralis:any;
declare var $: any;
const serverUrl = environment.moralisSerer;
const appId = environment.moralisKey;
// Moralis.start({ serverUrl, appId });

@Component({
  selector: 'app-mint',
  templateUrl: './mint.component.html',
  styleUrls: ['./mint.component.scss'],
})
export class MintComponent implements OnInit {

  _collection: FormGroup;
  _mint: FormGroup;
  _nftcategory:any;
  _nftimage:any;
  _nftimagename:any;

  _collectioncategory:any;
  _collectionimage:any;
  _collectionimagename:any;
  _collectionid:any;
  _collectiontitle:any;

  _collections:any;

  _mediaurl:any;
  _medianame:any;

  _termsagreed:any;
  _service:any;
  _user:any;
  _connected:any;
  _ismobile:any

  _ENS: any;
  _NFT: any;
  _fileUploading:any;
  _toFile:any;
  _imageuri:any;

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
    { id: 4, name: 'Promo\'s' },
    { id: 5, name: 'Photography' },
    { id: 6, name: 'NSFW Art' },
    { id: 7, name: 'NSFW Photo' }

  ];
  constructor(private formBuilder: FormBuilder,private service_: SERVICE,private zone: NgZone, private cd: ChangeDetectorRef,private route: ActivatedRoute,private router: Router) {

    this._service = service_;
    this._termsagreed = false;
    this.createForm();

  }

  ngOnInit() {

    this._user = localStorage.getItem('user');
    if(this._user){

      this.getusercollections();

    }
  }

  async getConnected(){

  }

  async getusercollections(){

    this._service.GETUSERCOLLECTIONS(this._user)
    .then((res:any)=>{
      this._collections = []
      if(res.length>0){
        for (let i = 0; i < res.length; i++) {
          const element = res[i];
          // console.log(element);
            this._service.GETCOLLECTION(element)
            .then((res:any)=>{

              this._collections.push(res);

            })
        }


      }
    })

  }
  async setcollection(collectionid_:any, collectiontitle_:any) {

    this._collectionid = collectionid_;
    this._collectiontitle = collectiontitle_;
    // console.log(this._collectionid)
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

  this._fileUploading = true;
  this._toFile = event.target.files[0]
  const imageFile = new Moralis.File(this._toFile.name,this._toFile)
  await imageFile.saveIPFS();
  this._imageuri= await imageFile.ipfs();
  this.zone.run(()=>{
    if(type==1){
      //nft image
      this._nftimage = this._imageuri
      this._nftimagename = this._toFile.name
      this._fileUploading = false;

    }else if(type==2){
      //collection image
      this._collectionimage = this._imageuri
      this._collectionimagename = this._toFile.name
      if(this._collectionimage){
        this._fileUploading = false;
      //  console.log(this.mediaURL)
      }
    }else if(type==3){
//    media file
      this._mediaurl = this._imageuri
      this._medianame = this._toFile.name
      if(this._mediaurl){
        this._fileUploading = false;
      //  console.log(this.mediaURL)
      }
    }
  })
}

async createcollection(){

  let pass = true;

  if(!this._collectionimage){

    this.pop('error', 'whats the collection image?');
    pass = false;

  }
  if(!this._collection.controls.title.value && pass){

    this.pop('error', 'whats the collection title?');
    pass = false;

  }
  if(!this._collection.controls.desc.value && pass){

    this.pop('error', 'whats the collection description?');
    pass = false;

  }
  if(!this._collectioncategory && pass){

    this.pop('error', 'whats the collection category?');
    pass = false;

  }
  if(pass){

    this._service.SETCOLLECTION(this._user,this._collectionimage,this._collection.controls.title.value,this._collection.controls.desc.value, this._collectioncategory)
    .then((res:any)=>{

    })
  }
}

async createmint(){

    let payto_:any;
    let pass = true;

    if(!this._nftimage){

      this.pop('error', 'whats the nft image?');
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
      this._service.createmint(this._user, this._nftimage, this._mint.controls.title.value, this._mint.controls.desc.value,  this._mint.controls.prints.value, payto_, this._mint.controls.royalty.value,this._mint.controls.redeems.value, this._nftcategory)
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
          this._nftcategory = e.target.value;

        }else{
          this._collectioncategory = e.target.value;
        }
       // console.log(this._nftcategory);
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
