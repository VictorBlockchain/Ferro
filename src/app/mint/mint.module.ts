import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MintRoutingModule } from './mint-routing.module';
import { MintComponent } from './mint.component';
import { ReactiveFormsModule } from "@angular/forms";

@NgModule({
  imports: [CommonModule, MintRoutingModule,ReactiveFormsModule],
  declarations: [MintComponent],
})
export class MintModule {}
