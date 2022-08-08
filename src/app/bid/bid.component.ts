import { Component, OnInit,AfterViewInit } from '@angular/core';
import { finalize } from 'rxjs/operators';
declare var $: any;
declare var swiper:any;

@Component({
  selector: 'app-bid',
  templateUrl: './bid.component.html',
  styleUrls: ['./bid.component.scss'],
})
export class BidComponent implements OnInit {
  isLoading = false;

  constructor() {}

  ngOnInit() {


  }
}
