import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from '@shared';
import { BidRoutingModule } from './bid-routing.module';
import { BidComponent } from './bid.component';

@NgModule({
  imports: [CommonModule, SharedModule, BidRoutingModule],
  declarations: [BidComponent],
})
export class BidModule {}
