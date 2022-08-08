import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';

const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'start', component: HomeComponent },
  {
path: 'bid',
loadChildren: () => import('./bid/bid.module')
  .then(mod => mod.BidModule)
},{
path: 'mint',
loadChildren: () => import('./mint/mint.module')
  .then(mod => mod.MintModule)
},{
path: 'wallet',
loadChildren: () => import('./wallet/wallet.module')
  .then(mod => mod.WalletModule)
},{
path: 'market',
loadChildren: () => import('./market/market.module')
  .then(mod => mod.MarketModule)
}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
