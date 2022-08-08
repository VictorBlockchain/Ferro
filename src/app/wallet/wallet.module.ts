import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from '@shared';
import { WalletRoutingModule } from './wallet-routing.module';
import { WalletComponent } from './wallet.component';

@NgModule({
  imports: [CommonModule, SharedModule, WalletRoutingModule],
  declarations: [WalletComponent],
})
export class WalletModule {}
