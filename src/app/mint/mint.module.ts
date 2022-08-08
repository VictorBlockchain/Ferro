import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from '@shared';
import { MintRoutingModule } from './mint-routing.module';
import { MintComponent } from './mint.component';
import { ReactiveFormsModule } from "@angular/forms";

@NgModule({
  imports: [CommonModule, SharedModule, MintRoutingModule,ReactiveFormsModule],
  declarations: [MintComponent],
})
export class MintModule {}
