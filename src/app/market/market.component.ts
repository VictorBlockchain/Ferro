import { Component, OnInit,AfterViewInit } from '@angular/core';
import { finalize } from 'rxjs/operators';
declare var $: any;
declare var swiper:any;

@Component({
  selector: 'app-market',
  templateUrl: './market.component.html',
  styleUrls: ['./market.component.scss'],
})
export class MarketComponent implements OnInit,AfterViewInit {
  quote: string | undefined;
  isLoading = false;

  constructor() {}

  ngOnInit() {
    this.isLoading = true;
    // this.quoteService
    //   .getRandomQuote({ category: 'dev' })
    //   .pipe(
    //     finalize(() => {
    //       this.isLoading = false;
    //     })
    //   )
    //   .subscribe((quote: string) => {
    //     this.quote = quote;
    //   });

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
}
