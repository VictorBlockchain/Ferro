import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BidRoutingModule } from './bid-routing.module';
import { BidComponent } from './bid.component';
import { ReactiveFormsModule } from "@angular/forms";

@NgModule({
  imports: [CommonModule, BidRoutingModule,ReactiveFormsModule],
  declarations: [BidComponent],
})
export class BidModule {}
