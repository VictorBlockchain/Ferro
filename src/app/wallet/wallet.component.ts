import { Component, OnInit, AfterViewInit, ViewChild, ElementRef, ViewChildren, QueryList, NgZone, ChangeDetectionStrategy, ChangeDetectorRef, Input} from "@angular/core";
import { FormGroup, FormBuilder, FormControl, Validators } from '@angular/forms';
import {  Router, ActivatedRoute, ParamMap } from '@angular/router';
import { finalize } from 'rxjs/operators';
import { SERVICE } from '../service/web3.service';
import { environment } from '../../environments/environment';
declare var Moralis:any;
declare var $: any;
const serverUrl = environment.moralisSerer;
const appId = environment.moralisKey;
Moralis.start({ serverUrl, appId });

@Component({
  selector: 'app-wallet',
  templateUrl: './wallet.component.html',
  styleUrls: ['./wallet.component.scss'],
})
export class WalletComponent implements OnInit,AfterViewInit {

  _editProfile: FormGroup;
  _service:any;
  _user:any;
  _username:any;
  _connected:any;
  _profile:any;
  _message:any;
  _messagetype:any;
  _wallets:any;

  constructor(private formBuilder: FormBuilder,private service_: SERVICE,private zone: NgZone, private cd: ChangeDetectorRef,private route: ActivatedRoute,private router: Router) {

    this._service = service_;
    this._profile = {};
    this.createForm();

  }

  ngOnInit() {

        this._user = localStorage.getItem('user');
        this._username = localStorage.getItem('username');
        if(this._user){
          this._connected = true;
          this.start();
          //this.router.navigate(['/wallet']);
        }

  }

  async start(){

    const _uProfile = Moralis.Object.extend("profile");
    const _query = new Moralis.Query(_uProfile);
    _query.equalTo('user',this._user);
    const results = await _query.first();
    if(results){

      this._profile.name =  results.get('name');
      this._profile.story =  results.get('story');
      this.getwallets();
      // console.log(this._profile);

    }else{
      console.log('nothing saved')
    }
  }

  async getwallets(){

    this._service.GETUSERWALLET(this._user)
    .then((res:any)=>{
      this._wallets = res[1];
      //console.log(res);
    })
  }

  async editprofile(){

    let pass = true;
    if(!this._editProfile.controls.email.value){

      this._message = 'whats your email?';
      pass = false;

    }
    if(!this._editProfile.controls.story.value && pass){

      this._message = 'whats your story?';
      pass = false;
    }
    if(pass){

      this._message = '';
      this._service.SETUSERWALLET(this._user,this._username, this._editProfile.controls.email.value,this._editProfile.controls.story.value, this._editProfile.controls.avatarcontract.value, this._editProfile.controls.avatarid.value)
      .then((res:any)=>{
        console.log(res)
          if(res.success){

          }else{

          }
      })
    }
  }

  ngAfterViewInit() {
    // $('.h-banner-slider').slick({
    //   dots: false,
    //   slidesToShow: 1,
    //   infinite: true,
    //   centerMode: true,
    //   centerPadding: '50px',
    //   arrows: false,
    //   slidesToScroll: 1,
    //   responsive: [
    //     {
    //       breakpoint: 475,
    //       settings: {
    //         centerPadding: '20px',
    //       },
    //     },
    //
    //     {
    //       breakpoint: 375,
    //       settings: {
    //         centerPadding: '15px',
    //       },
    //     },
    //   ],
    // });
  }

  createForm(){

  this._editProfile = this.formBuilder.group({

    avatarcontract: [''],
    avatarid: [''],
    email: [''],
    story: [''],

  });

}
}
