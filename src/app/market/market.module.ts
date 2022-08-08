import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MarketRoutingModule } from './market-routing.module';
import { MarketComponent } from './market.component';
import { ReactiveFormsModule } from "@angular/forms";

@NgModule({
  imports: [CommonModule, MarketRoutingModule,ReactiveFormsModule],
  declarations: [MarketComponent],
})
export class MarketModule {}
