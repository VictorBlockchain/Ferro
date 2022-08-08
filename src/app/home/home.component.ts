import { Component, OnInit, AfterViewInit, ViewChild, ElementRef, ViewChildren, QueryList, NgZone, ChangeDetectionStrategy, ChangeDetectorRef, Input} from "@angular/core";
import { FormGroup, FormBuilder, FormControl, Validators } from '@angular/forms';
import {  Router, ActivatedRoute, ParamMap } from '@angular/router';
import { SERVICE } from '../service/web3.service';
import { environment } from '../../environments/environment';
declare var Moralis:any;
declare var $: any;
const serverUrl = environment.moralisSerer;
const appId = environment.moralisKey;
Moralis.start({ serverUrl, appId });

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
    if(this._user){
      this._connected = true;
      //this.router.navigate(['/wallet']);
    }
  }

  async getConnected() {

    let user = Moralis.User.current();

    if (! user) {

      user = await Moralis.authenticate({
        signingMessage: "Login & TellAFriend",
      })
        .then((res:any)=>{

          this._user = res.get("ethAddress");
          localStorage.setItem('user',this._user);

          this._connected = true;
          this.getusername();

        })
        .catch((error:any)=> {
          console.log(error);
        });

    }else{

      this._user = user.get("ethAddress");
      this._connected = true;

      this.getusername();

    }

  }

  async getusername(){

    // get ENS domain of an address
    const options = { address: this._user};
    await Moralis.Web3API.resolve.resolveAddress(options)
    .then((res:any)=>{

      console.log(res)

    })
    .catch((error:any)=> {
      console.log(error.name);
    });

  }

  async logout() {
    await Moralis.User.logOut();
    this._connected = false
    this._user = null;
    localStorage.clear();

    console.log("logged out");
  }

  async getuserens(){

  }

async getusernft(){


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
